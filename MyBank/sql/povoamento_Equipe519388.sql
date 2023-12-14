-- USE equipe519388;

--
-- Despejando dados para a tabela `agencia`
--

INSERT INTO `agencia` (`agencia_id`, `nome_agencia`, `salario_montante_total`, `cidade`) VALUES
(101, 'Banco Alpha', 8000, 'São Paulo'),
(103, 'Secure Finance', 4200, 'Manaus'),
(205, 'Financial Solutions', 3500, 'Rio de Janeiro'),
(309, 'Money Movers', 9000, 'Belo Horizonte'),
(412, 'Capital Bank', 4000, 'Brasília'),
(523, 'Coastal Finance', 7500, 'Recife'),
(633, 'NovaEra Investments', 3200, 'Salvador'),
(747, 'Global Trust Bank', 9500, 'Fortaleza'),
(809, 'City Savings', 5000, 'Curitiba'),
(910, 'Prosperity Bank', 8800, 'Porto Alegre');
-- SELECT * FROM agencia;

--
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`CPF`, `nome`, `RG`, `orgaoEmis`, `UF`) VALUES
('01234567898', 'Ricardo Almeida', '0123458', 'Detran', 'PR'),
('12345678901', 'João Silva', '1234561', 'SSP', 'SP'),
('23456789013', 'Carlos Pereira', '2345673', 'SSP', 'MG'),
('23456789019', 'Gabriel Santos', '2345679', 'SSP', 'MG'),
('45678901230', 'Mariana Costa', '4567890', 'Detran', 'DF'),
('45678901234', 'Ana Santos', '4567894', 'Detran', 'DF'),
('56789012345', 'Pedro Costa', '5678905', 'SSP', 'PE'),
('78901234566', 'Lúcia Souza', '7890126', 'Detran', 'BA'),
('89012345677', 'Fernanda Lima', '8901237', 'SSP', 'CE'),
('98765432102', 'Maria Oliveira', '9876542', 'Detran', 'RJ');

--
-- Despejando dados para a tabela `clientes_emails`
--

INSERT INTO `clientes_emails` (`email`, `tipoEmail`, `cliente_CPF`) VALUES
('ricardo.almeida@email.com', 'Outro', '01234567898'),
('joao.silva@email.com', 'Pessoal', '12345678901'),
('carlos.pereira@email.com', 'Outro', '23456789013'),
('gabriel.santos@email.com', 'Trabalho', '23456789019'),
('mariana.costa@email.com', 'Pessoal', '45678901230'),
('ana.santos@email.com', 'Pessoal', '45678901234'),
('pedro.costa@email.com', 'Pessoal', '56789012345'),
('lucia.souza@email.com', 'Trabalho', '78901234566'),
('fernanda.lima@email.com', 'Pessoal', '89012345677'),
('maria.oliveira@email.com', 'Trabalho', '98765432102');

--
-- Despejando dados para a tabela `cliente_endereco`
--

INSERT INTO `cliente_endereco` (`tipoLogradouro`, `nomeLogradouro`, `numero`, `bairro`, `CEP`, `cidade`, `estado`, `cliente_CPF`) VALUES
('Rua', 'Rua das Cerejeiras', '505', 'Vila Nova', '78901-234', 'Curitiba', 'PR', '01234567898'),
('Rua', 'Rua das Flores', '123', 'Centro', '12345-678', 'São Paulo', 'SP', '12345678901'),
('Alameda', 'Alameda dos Anjos', '789', 'Jardim América', '23456-789', 'Belo Horizonte', 'MG', '23456789013'),
('Avenida', 'Avenida dos Flamboyants', '606', 'Jardim do Lago', '89012-345', 'Porto Alegre', 'RS', '23456789019'),
('Rua', 'Rua das Violetas', '707', 'Parque das Flores', '90123-456', 'Manaus', 'AM', '45678901230'),
('Rua', 'Rua das Palmeiras', '101', 'Jardim Botânico', '34567-890', 'Brasília', 'DF', '45678901234'),
('Avenida', 'Avenida da Praia', '202', 'Praia do Sol', '45678-901', 'Recife', 'PE', '56789012345'),
('Travessa', 'Travessa das Estrelas', '303', 'Centro Histórico', '56789-012', 'Salvador', 'BA', '78901234566'),
('Avenida', 'Avenida dos Girassóis', '404', 'Setor Sul', '67890-123', 'Fortaleza', 'CE', '89012345677'),
('Avenida', 'Avenida do Bosque', '456', 'Parque Industrial', '98765-432', 'Rio de Janeiro', 'RJ', '98765432102');

--
-- Despejando dados para a tabela `cliente_telefone`
--

INSERT INTO `cliente_telefone` (`telefone`, `tipoTelefone`, `cliente_CPF`) VALUES
('0123-4567', 'Residencial', '01234567898'),
('1234-5678', 'Residencial', '12345678901'),
('2345-6789', 'Celular', '23456789013'),
('2345-6789', 'Celular', '23456789019'),
('4567-8901', 'Comercial', '45678901230'),
('4567-8901', 'Residencial', '45678901234'),
('5678-9012', 'Celular', '56789012345'),
('7890-1234', 'Comercial', '78901234566'),
('8901-2345', 'Celular', '89012345677'),
('9876-5432', 'Comercial', '98765432102');

--
-- Despejando dados para a tabela `funcionario`
--

INSERT INTO `funcionario` (`id`, `matricula`, `nome_funcionario`, `senha`, `endereco`, 
`cidade`, `cargo`, `sexo`, `dataNasc`, `salario`, `AGENCIA_agencia_id`) VALUES
(1, 12341, 'Ana Souza', '55a5e9e78207b4df8699d60886fa070079463547b095d1a05bc719bb4e6cd251', 'Rua das Flores, 123', 
'São Paulo', 'gerente', 'feminino', '1980-03-12', 8000, 101),
(2, 67892, 'Pedro Lima', '6b08d780140e292a4af8ba3f2333fc1357091442d7e807c6cad92e8dcd0240b7', 'Avenida do Bosque, 456', 
'Rio de Janeiro', 'atendente', 'masculino', '1990-06-25', 3500, 205),
(3, 23453, 'Mariana Silva', 'b578dc5fcbfabbc7e96400601d0858c951f04929faef033bbbc117ab935c6ae9', 'Alameda dos Anjos, 789', 
'Belo Horizonte', 'gerente', 'feminino', '1985-09-18', 9000, 309),
(4, 78904, 'Carlos Oliveira', '4dbd4e8fdfeeb99bb9f59a0d018efd61199cb09af49a8c2d733648a583163d43', 'Rua das Palmeiras, 101', 
'Brasília', 'atendente', 'masculino', '1977-12-01', 4000, 412),
(5, 1235, 'Lúcia Costa', '70213e9ef0abf2ed32575dd9425e339907473d4d0635a518b6b37a35ca5b0c77', 'Avenida da Praia, 202', 
'Recife', 'gerente', 'feminino', '1990-04-02', 7500, 523),
(6, 56786, 'João Santos', '2b378332fb0437149d24b1202deb1e6a00ce8f8389eb5181141cfbf188fa692f', 
'Travessa das Estrelas, 303', 'Salvador', 'atendente', 'masculino', '1988-07-15', 3200, 633),
(7, 89017, 'Fernanda Almeida', '2288821c6b799cf47a8c9aa231f361ffb906bbee0d5fb5e1767509e27442cc62', 
'Avenida dos Girassóis, 404', 'Fortaleza', 'gerente', 'feminino', '1982-10-28', 9500, 747),
(8, 34568, 'Ricardo Lima', '236e4f766857c3417431a08aae7c387e310693a7ebb9f33c32924350d73d9a67', 
'Rua das Cerejeiras, 505', 'Curitiba', 'atendente', 'masculino', '1979-01-09', 5000, 809),
(9, 67899, 'Gabriel Costa', 'b578dc5fcbfabbc7e96400601d0858c951f04929faef033bbbc117ab935c6ae9', 
'Avenida dos Flamboyants, 606', 'Porto Alegre', 'gerente', 'masculino', '1985-02-22', 8800, 910),
(10, 23450, 'Mariana Lima', '4dbd4e8fdfeeb99bb9f59a0d018efd61199cb09af49a8c2d733648a583163d43', 
'Rua das Violetas, 707', 'Manaus', 'atendente', 'feminino', '1977-05-06', 4200, 103);

--
-- Despejando dados para a tabela `dependente`
--

INSERT INTO `dependente` (`id`, `nome`, `dataNasc`, `parentesco`, `idade`, `FUNCIONARIO_id`) VALUES
(1, 'Maria', '2001-01-01', 'filho(a)', 22, 1),
(2, 'Joana', '2001-01-01', 'filho(a)', 22, 1),
(3, 'Paulo', '2001-01-01', 'filho(a)', 22, 1),
(4, 'Matehus', '2001-01-01', 'filho(a)', 22, 1);

--
-- Despejando dados para a tabela `conta`
--

INSERT INTO `conta` (`numConta`, `saldo`, `senha`, `tipo_conta`, `conta_unica_conjunta`, `AGENCIA_ID`, `funcionario_id`, `cliente_CPF`, 
`cpf2`, `taxa_juros`, `data_aniversario_contrato`, `limite_credito`) VALUES
(112, 10000, 'eb01dd90291c243ab2bfd5716c6b6bccd2a579c5bb5a1b987fb930bc5b78fbca', 'corrente', 'unica', 205, 3, '23456789013', 
NULL, NULL, '2022-10-02', NULL),
(1234, 0, '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'corrente', 'unica', 101, 1, '01234567898', 
NULL, NULL, '2022-10-02', NULL),
(4321, 0, 'fe2592b42a727e977f055947385b709cc82b16b9a87f88c6abf3900d65d0cdc3', 'corrente', 'unica', 103, 5, '12345678901', 
NULL, NULL, '2022-10-02', NULL);

--
-- Despejando dados para a tabela `transacao`
--

INSERT INTO `transacao` (`id_transacao`, `numero_transacao`, `tipo`, `data_hora`, `valor`, 
`conta_numConta`, `conta_destino_numConta`) VALUES
(1, 1, 'deposito', '2023-11-29 10:00:00', 10000, 112, NULL);

