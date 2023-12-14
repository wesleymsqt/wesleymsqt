-- DROP DATABASE equipe519388;
-- CREATE DATABASE equipe519388;
-- USE equipe519388;
 
 -- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 29/11/2023 às 21:31
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `equipe519388`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agencia`
--

CREATE TABLE `agencia` (
  `agencia_id` int(11) NOT NULL,
  `nome_agencia` varchar(90) NOT NULL,
  `salario_montante_total` float DEFAULT NULL COMMENT 'Deve ser calculado / atualizado a cada inserção / atualização / remoção de funcionário na agência.',
  `cidade` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `CPF` varchar(11) NOT NULL,
  `nome` varchar(90) NOT NULL,
  `RG` varchar(15) NOT NULL COMMENT 'Marcamos Unique pois não pode ter CPF repetido.',
  `orgaoEmis` varchar(45) NOT NULL,
  `UF` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Estrutura para tabela `clientes_emails`
--

CREATE TABLE `clientes_emails` (
  `email` varchar(60) NOT NULL,
  `tipoEmail` varchar(45) DEFAULT NULL,
  `cliente_CPF` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `clientes_emails`
--
DELIMITER $$
CREATE TRIGGER `verifica_cpf_email` BEFORE INSERT ON `clientes_emails` FOR EACH ROW BEGIN
    DECLARE countCPF INT;

    SELECT COUNT(*) INTO countCPF
    FROM cliente
    WHERE CPF = NEW.cliente_CPF;

    IF countCPF = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF não encontrado na tabela cliente';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente_endereco`
--

CREATE TABLE `cliente_endereco` (
  `tipoLogradouro` varchar(45) NOT NULL,
  `nomeLogradouro` varchar(45) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `bairro` varchar(45) NOT NULL,
  `CEP` varchar(10) NOT NULL,
  `cidade` varchar(45) NOT NULL,
  `estado` varchar(45) NOT NULL,
  `cliente_CPF` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `cliente_endereco`
--
DELIMITER $$
CREATE TRIGGER `verifica_cpf_endereco` BEFORE INSERT ON `cliente_endereco` FOR EACH ROW BEGIN
    DECLARE countCPF INT;

    SELECT COUNT(*) INTO countCPF
    FROM cliente
    WHERE CPF = NEW.cliente_CPF;

    IF countCPF = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF não encontrado na tabela cliente';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente_telefone`
--

CREATE TABLE `cliente_telefone` (
  `telefone` varchar(15) NOT NULL,
  `tipoTelefone` varchar(45) NOT NULL,
  `cliente_CPF` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `cliente_telefone`
--
DELIMITER $$
CREATE TRIGGER `verifica_cpf_telefone` BEFORE INSERT ON `cliente_telefone` FOR EACH ROW BEGIN
    DECLARE countCPF INT;

    SELECT COUNT(*) INTO countCPF
    FROM cliente
    WHERE CPF = NEW.cliente_CPF;

    IF countCPF = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF não encontrado na tabela cliente';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `conta`
--

CREATE TABLE `conta` (
  `numConta` int(11) NOT NULL,
  `saldo` float DEFAULT 0,
  `senha` varchar(256) NOT NULL,
  `tipo_conta` enum('corrente','poupanca','especial') NOT NULL,
  `conta_unica_conjunta` enum('unica','conjunta') NOT NULL,
  `AGENCIA_ID` int(11) NOT NULL,
  `funcionario_id` int(11) NOT NULL,
  `cliente_CPF` varchar(11) NOT NULL,
  `cpf2` varchar(11) DEFAULT NULL,
  `taxa_juros` decimal(5,2) DEFAULT NULL,
  `data_aniversario_contrato` date DEFAULT NULL,
  `limite_credito` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `conta`
--
DELIMITER $$
CREATE TRIGGER `before_insert_conta` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    IF NEW.conta_unica_conjunta = 'unica' THEN
        IF NEW.cliente_CPF IS NULL OR NEW.cpf2 IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Para conta unica, apenas cliente_CPF deve ser especificado.';
        END IF;
    ELSE
        IF NEW.cliente_CPF IS NULL OR NEW.cpf2 IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Para conta conjunta, ambos cliente_CPF e cpf2 devem ser especificados.';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `criptografa_senha` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    SET NEW.senha = SHA2(NEW.senha, 256);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `definir_valores_conta_corrente` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    -- Se o tipo_conta for 'corrente', define as colunas conforme necessário
    IF NEW.tipo_conta = 'corrente' THEN
        SET NEW.limite_credito = NULL;
        SET NEW.taxa_juros = NULL;
        
        -- Verifica se a data_aniversario_contrato é fornecida; se não, gera um sinal de erro
        IF NEW.data_aniversario_contrato IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A data_aniversario_contrato é obrigatória para contas do tipo corrente';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `definir_valores_conta_especial` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    -- Se o tipo_conta for 'especial', define as colunas conforme necessário
    IF NEW.tipo_conta = 'especial' THEN
        SET NEW.taxa_juros = NULL;
        SET NEW.data_aniversario_contrato = NULL;

        -- Verifica se o limite_credito é fornecido; se não, gera um sinal de erro
        IF NEW.limite_credito IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O limite_credito é obrigatório para contas do tipo especial';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `definir_valores_conta_poupanca` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    -- Se o tipo_conta for 'poupanca', define as colunas conforme necessário
    IF NEW.tipo_conta = 'poupanca' THEN
        SET NEW.limite_credito = NULL;
        SET NEW.data_aniversario_contrato = NULL;
        
        -- Verifica se a taxa_juros é fornecida; se não, gera um sinal de erro
        IF NEW.taxa_juros IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A taxa_juros é obrigatória para contas do tipo poupanca';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `saldo_zerado` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    SET NEW.saldo = 0;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `valida_gerente_conta` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    DECLARE is_gerente BOOLEAN;

    -- Verifica se o funcionário correspondente é um gerente
    SELECT TRUE INTO is_gerente
    FROM equipe519388.funcionario
    WHERE id = NEW.funcionario_id AND cargo = 'gerente';

    -- Se o funcionário não for um gerente, gera um sinal de erro
    IF is_gerente IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Somente gerentes podem ser associados a contas';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verifica_agencia_existente` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    DECLARE agencia_existente INT;

    -- Verifica se o AGENCIA_ID fornecido existe na tabela agencia
    SELECT COUNT(*)
    INTO agencia_existente
    FROM agencia
    WHERE agencia_id = NEW.AGENCIA_ID;

    -- Se a agência não existe, impede a inserção
    IF agencia_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A agência fornecida não existe';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verifica_agencia_existente_update` BEFORE UPDATE ON `conta` FOR EACH ROW BEGIN
    DECLARE agencia_existente INT;

    -- Verifica se o AGENCIA_ID fornecido existe na tabela agencia
    SELECT COUNT(*)
    INTO agencia_existente
    FROM agencia
    WHERE agencia_id = NEW.AGENCIA_ID;

    -- Se a agência não existe, impede a inserção
    IF agencia_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A agência fornecida não existe';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verifica_conta_cliente_agencia_insert` BEFORE INSERT ON `conta` FOR EACH ROW BEGIN
    DECLARE total_contas INT;

    -- Verifica o número de contas do cliente na mesma agência
    SELECT COUNT(*) INTO total_contas
    FROM equipe519388.conta
    WHERE cliente_CPF = NEW.cliente_CPF
        AND AGENCIA_ID = NEW.AGENCIA_ID;

    -- Se o cliente já tem uma conta na mesma agência, impede a inserção
    IF total_contas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O cliente já possui uma conta nesta agência';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dependente`
--

CREATE TABLE `dependente` (
  `id` int(11) NOT NULL,
  `nome` varchar(90) NOT NULL COMMENT 'Unico por funcionário',
  `dataNasc` date DEFAULT NULL,
  `parentesco` enum('filho(a)','conjugue','genitor') NOT NULL COMMENT 'Se é filho(a), cônjuge ou genitor(a)',
  `idade` int(11) NOT NULL COMMENT 'Que deve ser calculada.',
  `FUNCIONARIO_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `dependente`
--
DELIMITER $$
CREATE TRIGGER `calcular_idade_dependente` BEFORE INSERT ON `dependente` FOR EACH ROW BEGIN
    SET NEW.idade = YEAR(CURDATE()) - YEAR(NEW.dataNasc);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_numero_dependentes` BEFORE INSERT ON `dependente` FOR EACH ROW BEGIN
    DECLARE numero_dependentes INT;

    -- Conta o número atual de dependentes para o funcionário
    SELECT COUNT(*) INTO numero_dependentes
    FROM dependente
    WHERE FUNCIONARIO_id = NEW.FUNCIONARIO_id;

    -- Verifica se o número de dependentes é menor que 5
    IF numero_dependentes >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O funcionário já possui o número máximo de dependentes permitidos.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
--

CREATE TABLE `funcionario` (
  `id` int(11) NOT NULL,
  `matricula` int(11) NOT NULL,
  `nome_funcionario` varchar(90) NOT NULL,
  `senha` varchar(5256) NOT NULL,
  `endereco` text NOT NULL,
  `cidade` varchar(90) NOT NULL,
  `cargo` enum('gerente','atendente','caixa') NOT NULL COMMENT 'Podendo ser gerente, atendente ou caixa.',
  `sexo` enum('masculino','feminino') NOT NULL,
  `dataNasc` date NOT NULL,
  `salario` float NOT NULL COMMENT 'Não podendo este ser menor que R$2.286,00, salário-base da categoria',
  `AGENCIA_agencia_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `funcionario`
--
DELIMITER $$
CREATE TRIGGER `atualiza_montante_total_agencia` AFTER INSERT ON `funcionario` FOR EACH ROW BEGIN
    DECLARE agencia_montante_total FLOAT;

    -- Calcula o montante total da agência específica
    SELECT SUM(salario) INTO agencia_montante_total
    FROM funcionario
    WHERE AGENCIA_agencia_id = NEW.AGENCIA_agencia_id;

    -- Atualiza o montante total na tabela de agências
    UPDATE agencia
    SET salario_montante_total = agencia_montante_total
    WHERE agencia_id = NEW.AGENCIA_agencia_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `atualizar_montante_total_exclusao` AFTER DELETE ON `funcionario` FOR EACH ROW BEGIN
    DECLARE total_salario FLOAT;

    -- Calcula o novo total de salários para a agência
    SELECT SUM(salario) INTO total_salario
    FROM Funcionario
    WHERE AGENCIA_agencia_id = OLD.AGENCIA_agencia_id;

    -- Atualiza o salario_montante_total da agência
    UPDATE Agencia
    SET salario_montante_total = total_salario
    WHERE agencia_id = OLD.AGENCIA_agencia_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `criptografa_senha_` BEFORE INSERT ON `funcionario` FOR EACH ROW BEGIN
    SET NEW.senha = SHA2(NEW.senha, 256);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `funcionario_AFTER_UPDATE` AFTER UPDATE ON `funcionario` FOR EACH ROW BEGIN
DECLARE total_salario FLOAT;

    -- Calcula o novo total de salários para a agência
    SELECT SUM(salario) INTO total_salario
    FROM Funcionario
    WHERE AGENCIA_agencia_id = NEW.AGENCIA_agencia_id;

    -- Atualiza o salario_montante_total da agência
    UPDATE Agencia
    SET salario_montante_total = total_salario
    WHERE agencia_id = NEW.AGENCIA_agencia_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `recalcular_montante_agencia` AFTER UPDATE ON `funcionario` FOR EACH ROW BEGIN
    UPDATE equipe519388.agencia AS a
    SET a.salario_montante_total = (
        SELECT SUM(f.salario)
        FROM equipe519388.funcionario AS f
        WHERE f.AGENCIA_agencia_id = NEW.AGENCIA_agencia_id
    )
    WHERE a.agencia_id = NEW.AGENCIA_agencia_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `recalcular_montante_agencia_del` AFTER DELETE ON `funcionario` FOR EACH ROW BEGIN
    UPDATE equipe519388.agencia AS a
    SET a.salario_montante_total = (
        SELECT SUM(f.salario)
        FROM equipe519388.funcionario AS f
        WHERE f.AGENCIA_agencia_id = OLD.AGENCIA_agencia_id
    )
    WHERE a.agencia_id = OLD.AGENCIA_agencia_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `valida_agencia_existente` BEFORE INSERT ON `funcionario` FOR EACH ROW BEGIN
    DECLARE agencia_existe INT;

    -- Verifica se o ID da agência existe na tabela de agências
    SELECT COUNT(*) INTO agencia_existe
    FROM agencia
    WHERE agencia_id = NEW.AGENCIA_agencia_id;

    -- Se o ID da agência não existir, gera um erro
    IF agencia_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A agência especificada não existe. Insira um ID de agência válido para cadastrar o funcionário.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `valida_agencia_existente_update` BEFORE UPDATE ON `funcionario` FOR EACH ROW BEGIN
    DECLARE agencia_existe INT;

    -- Verifica se o ID da agência existe na tabela de agências
    SELECT COUNT(*) INTO agencia_existe
    FROM agencia
    WHERE agencia_id = NEW.AGENCIA_agencia_id;

    -- Se o ID da agência não existir, gera um erro
    IF agencia_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A agência especificada não existe. Insira um ID de agência válido para cadastrar o funcionário.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_salario` BEFORE INSERT ON `funcionario` FOR EACH ROW BEGIN
    -- Garante que o salário não seja menor que R$2.286,00
    IF NEW.salario < 2286.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O salário não pode ser menor que R$2.286,00';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_salario_update` BEFORE UPDATE ON `funcionario` FOR EACH ROW BEGIN
    -- Garante que o salário não seja menor que R$2.286,00
    IF NEW.salario < 2286.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O salário não pode ser menor que R$2.286,00';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `transacao`
--

CREATE TABLE `transacao` (
  `id_transacao` int(11) NOT NULL,
  `numero_transacao` int(11) NOT NULL,
  `tipo` enum('saque','deposito','pagamento','transferencia','estorno') NOT NULL COMMENT 'podendo ser saque, depósito, pagamento, estorno ou transferência',
  `data_hora` datetime NOT NULL,
  `valor` float NOT NULL,
  `conta_numConta` int(11) NOT NULL,
  `conta_destino_numConta` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--
-- Acionadores `transacao`
--
DELIMITER $$
CREATE TRIGGER `deposito_trigger` BEFORE INSERT ON `transacao` FOR EACH ROW BEGIN
    -- Verificar se o tipo de transação é "deposito"
    IF NEW.tipo = 'deposito' THEN
        -- Verificar se o valor do depósito é positivo
        IF NEW.valor > 0 THEN
            -- Adicionar o valor do depósito à conta
            UPDATE equipe519388.conta
            SET saldo = saldo + NEW.valor
            WHERE numConta = NEW.conta_numConta;
        ELSE
            -- Se o valor do depósito for negativo, cancelar a operação
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor do depósito inválido. Operação cancelada.';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `estorno_trigger` BEFORE INSERT ON `transacao` FOR EACH ROW BEGIN
    DECLARE original_valid BOOLEAN;

    -- Verificar se o tipo de transação é "estorno"
    IF NEW.tipo = 'estorno' THEN
        -- Verificar se a transação original existe e é válida
        SELECT TRUE INTO original_valid
        FROM equipe519388.transacao
        WHERE id_transacao = NEW.numero_transacao;

        IF original_valid THEN
            -- Subtrair o valor da conta que está realizando o estorno
            UPDATE equipe519388.conta
            SET saldo = saldo - NEW.valor
            WHERE numConta = NEW.conta_numConta;

            -- Adicionar o valor à conta que está sendo estornada
            UPDATE equipe519388.conta
            SET saldo = saldo + NEW.valor
            WHERE numConta = (
                SELECT conta_numConta
                FROM equipe519388.transacao
                WHERE id_transacao = NEW.numero_transacao
            );

            -- Inserir a transação de estorno
            -- Lembre-se de ajustar o saldo conforme necessário
            -- Aqui estamos apenas copiando os valores da transação original
            INSERT INTO equipe519388.transacao (tipo, data_hora, valor, conta_numConta)
            VALUES ('estorno', NEW.data_hora, NEW.valor, NEW.conta_numConta);
        ELSE
            -- Se a transação original não existir ou não for válida, cancelar a operação
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transação original inválida. Estorno cancelado.';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `pagamento_trigger` AFTER INSERT ON `transacao` FOR EACH ROW BEGIN
    DECLARE novo_saldo_origem FLOAT;
    DECLARE novo_saldo_destino FLOAT;

    -- Verificar se o tipo de transação é "pagamento"
    IF NEW.tipo = 'pagamento' THEN
        -- Verificar se a conta de envio possui saldo suficiente
        SELECT saldo INTO novo_saldo_origem
        FROM equipe519388.conta
        WHERE numConta = NEW.conta_numConta;

        IF novo_saldo_origem >= NEW.valor THEN
            -- Atualizar saldo na conta de envio
            SET novo_saldo_origem = novo_saldo_origem - NEW.valor;
            UPDATE equipe519388.conta SET saldo = novo_saldo_origem WHERE numConta = NEW.conta_numConta;

            -- Atualizar saldo na conta de recebimento
            SET novo_saldo_destino = (SELECT saldo FROM equipe519388.conta WHERE numConta = NEW.conta_destino_numConta) + NEW.valor;
            UPDATE equipe519388.conta SET saldo = novo_saldo_destino WHERE numConta = NEW.conta_destino_numConta;

        ELSE
            -- Se a conta de envio não tiver saldo suficiente, cancelar a operação
            DELETE FROM equipe519388.transacao WHERE id_transacao = NEW.id_transacao;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conta de envio sem saldo suficiente. Transferência cancelada.';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `realiza_saque` BEFORE INSERT ON `transacao` FOR EACH ROW BEGIN
    DECLARE saldo_atual FLOAT;
    
    -- Obtém o saldo atual da conta
    SELECT saldo INTO saldo_atual
    FROM conta
    WHERE numConta = NEW.conta_numConta;

    -- Verifica se o tipo de transação é um saque
    IF NEW.tipo = 'saque' THEN
        -- Verifica se o valor do saque é maior que o saldo atual
        IF NEW.valor > saldo_atual THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Saldo insuficiente para realizar o saque';
        ELSE
            -- Atualiza o saldo após o saque na tabela de contas
            UPDATE conta
            SET saldo = saldo_atual - NEW.valor
            WHERE numConta = NEW.conta_numConta;
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transferencia_trigger` AFTER INSERT ON `transacao` FOR EACH ROW BEGIN
    DECLARE novo_saldo_origem FLOAT;
    DECLARE novo_saldo_destino FLOAT;

    -- Verifica se o tipo de transação é "transferencia"
    IF NEW.tipo = 'transferencia' THEN
        -- Verifica se a conta de envio possui saldo suficiente
        SELECT saldo INTO novo_saldo_origem
        FROM equipe519388.conta
        WHERE numConta = NEW.conta_numConta;

        IF novo_saldo_origem >= NEW.valor THEN
            -- Atualiza saldo na conta de envio
            SET novo_saldo_origem = novo_saldo_origem - NEW.valor;
            UPDATE equipe519388.conta SET saldo = novo_saldo_origem WHERE numConta = NEW.conta_numConta;

            -- Atualiza saldo na conta de recebimento
            SET novo_saldo_destino = (SELECT saldo FROM equipe519388.conta WHERE numConta = NEW.conta_destino_numConta) + NEW.valor;
            UPDATE equipe519388.conta SET saldo = novo_saldo_destino WHERE numConta = NEW.conta_destino_numConta;

        ELSE
            -- Se a conta de envio não tiver saldo suficiente, cancelar a operação
            DELETE FROM equipe519388.transacao WHERE id_transacao = NEW.id_transacao;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conta de envio sem saldo suficiente. Transferência cancelada.';
        END IF;
    END IF;
END
$$
DELIMITER ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agencia`
--
ALTER TABLE `agencia`
  ADD PRIMARY KEY (`agencia_id`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`CPF`),
  ADD UNIQUE KEY `RG_UNIQUE` (`RG`),
  ADD UNIQUE KEY `CPF_UNIQUE` (`CPF`);

--
-- Índices de tabela `clientes_emails`
--
ALTER TABLE `clientes_emails`
  ADD PRIMARY KEY (`cliente_CPF`);

--
-- Índices de tabela `cliente_endereco`
--
ALTER TABLE `cliente_endereco`
  ADD PRIMARY KEY (`cliente_CPF`);

--
-- Índices de tabela `cliente_telefone`
--
ALTER TABLE `cliente_telefone`
  ADD PRIMARY KEY (`cliente_CPF`);

--
-- Índices de tabela `conta`
--
ALTER TABLE `conta`
  ADD PRIMARY KEY (`numConta`),
  ADD UNIQUE KEY `numConta_UNIQUE` (`numConta`),
  ADD KEY `fk_CONTA_AGENCIA1_idx` (`AGENCIA_ID`),
  ADD KEY `fk_conta_funcionario1_idx` (`funcionario_id`),
  ADD KEY `fk_conta_cliente1_idx` (`cliente_CPF`),
  ADD KEY `fk_conta_cliente2` (`cpf2`);

--
-- Índices de tabela `dependente`
--
ALTER TABLE `dependente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nome_UNIQUE` (`nome`),
  ADD KEY `fk_DEPENDENTE_FUNCIONARIO1_idx` (`FUNCIONARIO_id`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `matricula_UNIQUE` (`matricula`),
  ADD KEY `fk_FUNCIONARIO_AGENCIA1_idx` (`AGENCIA_agencia_id`);

--
-- Índices de tabela `transacao`
--
ALTER TABLE `transacao`
  ADD PRIMARY KEY (`id_transacao`),
  ADD UNIQUE KEY `numero_transacao_UNIQUE` (`numero_transacao`),
  ADD KEY `fk_transacao_conta1_idx` (`conta_numConta`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agencia`
--
ALTER TABLE `agencia`
  MODIFY `agencia_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=911;

--
-- AUTO_INCREMENT de tabela `dependente`
--
ALTER TABLE `dependente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `funcionario`
--
ALTER TABLE `funcionario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `transacao`
--
ALTER TABLE `transacao`
  MODIFY `id_transacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `clientes_emails`
--
ALTER TABLE `clientes_emails`
  ADD CONSTRAINT `fk_clientes_emails_cliente1` FOREIGN KEY (`cliente_CPF`) REFERENCES `cliente` (`CPF`);

--
-- Restrições para tabelas `cliente_endereco`
--
ALTER TABLE `cliente_endereco`
  ADD CONSTRAINT `fk_cliente_endereco_cliente1` FOREIGN KEY (`cliente_CPF`) REFERENCES `cliente` (`CPF`);

--
-- Restrições para tabelas `cliente_telefone`
--
ALTER TABLE `cliente_telefone`
  ADD CONSTRAINT `fk_cliente_telefone_cliente1` FOREIGN KEY (`cliente_CPF`) REFERENCES `cliente` (`CPF`);

--
-- Restrições para tabelas `conta`
--
ALTER TABLE `conta`
  ADD CONSTRAINT `fk_CONTA_AGENCIA1` FOREIGN KEY (`AGENCIA_ID`) REFERENCES `agencia` (`agencia_id`),
  ADD CONSTRAINT `fk_conta_cliente1` FOREIGN KEY (`cliente_CPF`) REFERENCES `cliente` (`CPF`),
  ADD CONSTRAINT `fk_conta_cliente2` FOREIGN KEY (`cpf2`) REFERENCES `cliente` (`CPF`),
  ADD CONSTRAINT `fk_conta_funcionario1` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`);

--
-- Restrições para tabelas `dependente`
--
ALTER TABLE `dependente`
  ADD CONSTRAINT `fk_DEPENDENTE_FUNCIONARIO1` FOREIGN KEY (`FUNCIONARIO_id`) REFERENCES `funcionario` (`id`);

--
-- Restrições para tabelas `funcionario`
--
ALTER TABLE `funcionario`
  ADD CONSTRAINT `fk_FUNCIONARIO_AGENCIA1` FOREIGN KEY (`AGENCIA_agencia_id`) REFERENCES `agencia` (`agencia_id`);

--
-- Restrições para tabelas `transacao`
--
ALTER TABLE `transacao`
  ADD CONSTRAINT `fk_transacao_conta1` FOREIGN KEY (`conta_numConta`) REFERENCES `conta` (`numConta`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
