USE `equipe519388`;

DELIMITER $$
USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verifica_cpf_endereco`
BEFORE INSERT ON `equipe519388`.`cliente_endereco`
FOR EACH ROW
BEGIN
    DECLARE countCPF INT;

    SELECT COUNT(*) INTO countCPF
    FROM cliente
    WHERE CPF = NEW.cliente_CPF;

    IF countCPF = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF não encontrado na tabela cliente';
    END IF;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verifica_cpf_telefone`
BEFORE INSERT ON `equipe519388`.`cliente_telefone`
FOR EACH ROW
BEGIN
    DECLARE countCPF INT;

    SELECT COUNT(*) INTO countCPF
    FROM cliente
    WHERE CPF = NEW.cliente_CPF;

    IF countCPF = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF não encontrado na tabela cliente';
    END IF;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verifica_cpf_email`
BEFORE INSERT ON `equipe519388`.`clientes_emails`
FOR EACH ROW
BEGIN
    DECLARE countCPF INT;

    SELECT COUNT(*) INTO countCPF
    FROM cliente
    WHERE CPF = NEW.cliente_CPF;

    IF countCPF = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF não encontrado na tabela cliente';
    END IF;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`atualiza_montante_total_agencia`
AFTER INSERT ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    DECLARE agencia_montante_total FLOAT;

    -- Calcula o montante total da agência específica
    SELECT SUM(salario) INTO agencia_montante_total
    FROM funcionario
    WHERE AGENCIA_agencia_id = NEW.AGENCIA_agencia_id;

    -- Atualiza o montante total na tabela de agências
    UPDATE agencia
    SET salario_montante_total = agencia_montante_total
    WHERE agencia_id = NEW.AGENCIA_agencia_id;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`atualizar_montante_total_exclusao`
AFTER DELETE ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    DECLARE total_salario FLOAT;

    -- Calcula o novo total de salários para a agência
    SELECT SUM(salario) INTO total_salario
    FROM Funcionario
    WHERE AGENCIA_agencia_id = OLD.AGENCIA_agencia_id;

    -- Atualiza o salario_montante_total da agência
    UPDATE Agencia
    SET salario_montante_total = total_salario
    WHERE agencia_id = OLD.AGENCIA_agencia_id;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`criptografa_senha_`
BEFORE INSERT ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    SET NEW.senha = SHA2(NEW.senha, 256);
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`funcionario_AFTER_UPDATE`
AFTER UPDATE ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
DECLARE total_salario FLOAT;

    -- Calcula o novo total de salários para a agência
    SELECT SUM(salario) INTO total_salario
    FROM Funcionario
    WHERE AGENCIA_agencia_id = NEW.AGENCIA_agencia_id;

    -- Atualiza o salario_montante_total da agência
    UPDATE Agencia
    SET salario_montante_total = total_salario
    WHERE agencia_id = NEW.AGENCIA_agencia_id;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`recalcular_montante_agencia`
AFTER UPDATE ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    UPDATE equipe519388.agencia AS a
    SET a.salario_montante_total = (
        SELECT SUM(f.salario)
        FROM equipe519388.funcionario AS f
        WHERE f.AGENCIA_agencia_id = NEW.AGENCIA_agencia_id
    )
    WHERE a.agencia_id = NEW.AGENCIA_agencia_id;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`recalcular_montante_agencia_del`
AFTER DELETE ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    UPDATE equipe519388.agencia AS a
    SET a.salario_montante_total = (
        SELECT SUM(f.salario)
        FROM equipe519388.funcionario AS f
        WHERE f.AGENCIA_agencia_id = OLD.AGENCIA_agencia_id
    )
    WHERE a.agencia_id = OLD.AGENCIA_agencia_id;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`valida_agencia_existente`
BEFORE INSERT ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`valida_agencia_existente_update`
BEFORE UPDATE ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verificar_salario`
BEFORE INSERT ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    -- Garante que o salário não seja menor que R$2.286,00
    IF NEW.salario < 2286.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O salário não pode ser menor que R$2.286,00';
    END IF;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verificar_salario_update`
BEFORE UPDATE ON `equipe519388`.`funcionario`
FOR EACH ROW
BEGIN
    -- Garante que o salário não seja menor que R$2.286,00
    IF NEW.salario < 2286.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O salário não pode ser menor que R$2.286,00';
    END IF;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`before_insert_conta`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`criptografa_senha`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
    SET NEW.senha = SHA2(NEW.senha, 256);
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`definir_data_aniversario_corrente`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
    -- Define a data de aniversário do contrato como um ano após a data atual
    SET NEW.data_aniversario_contrato = DATE_ADD(CURDATE(), INTERVAL 1 YEAR);
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`definir_valores_conta_especial`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`definir_valores_conta_poupanca`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`saldo_zerado`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
    SET NEW.saldo = 0;
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`valida_gerente_conta`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verifica_agencia_existente`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verifica_agencia_existente_update`
BEFORE UPDATE ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verifica_conta_cliente_agencia_insert`
BEFORE INSERT ON `equipe519388`.`conta`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`calcular_idade_dependente`
BEFORE INSERT ON `equipe519388`.`dependente`
FOR EACH ROW
BEGIN
    SET NEW.idade = YEAR(CURDATE()) - YEAR(NEW.dataNasc);
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`verificar_numero_dependentes`
BEFORE INSERT ON `equipe519388`.`dependente`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`pagamento_trigger`
AFTER INSERT ON `equipe519388`.`transacao`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`realiza_saque`
BEFORE INSERT ON `equipe519388`.`transacao`
FOR EACH ROW
BEGIN
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
END$$

USE `equipe519388`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `equipe519388`.`transferencia_trigger`
AFTER INSERT ON `equipe519388`.`transacao`
FOR EACH ROW
BEGIN
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
END$$


DELIMITER ;