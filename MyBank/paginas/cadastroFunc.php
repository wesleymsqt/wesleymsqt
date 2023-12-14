<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CADASTRO FUNCIONARIO</title>
    <link rel="stylesheet" href="../estilos/global.css">
    <link rel="stylesheet" href="../estilos/cadastro.css">
</head>

<body>
    <div class="page">
        <!-- COLETANDO AS INFORMAÇÕES DO CADASTRO DO FUNCIONÁRIO -->
        <form class="formCad" method="POST" action="../php/cadastrarFunc.php">
                <h3 class="subtitle">Informações para cadastro</h3>
                <div class="content-separator">
                    <div class="input-content">
                        <label for="matricula">Matricula</label>
                        <input type="text" name="matricula" placeholder="Preencher campo" required>
                    </div>
                    <div class="input-content">
                        <label for="nome">Nome completo</label>
                        <input type="text" name="nome" placeholder="Preencher campo" required>
                    </div>
                    <div class="input-content">
                        <label for="senha">Senha</label>
                        <input type="password" name="senha" placeholder="Preencher campo" required>
                    </div>
                    <div class="input-content">
                    </div>
                </div>
                <div class="content-separator">
                    <div class="input-content">
                        <label for="endereco">Endereço</label>
                        <input type="text" name="endereco" placeholder="Preencher campo" required>
                    </div>
                    <div class="input-content">
                        <label for="cidade">Cidade</label>
                        <input type="text" name="cidade" placeholder="Preencher campo" required>
                    </div>
                </div>
                <div class="content-separator">
                    <div class="input-content">
                        <label for="tipo_conta">Cargo</label>
                        <select name="cargo">
                            <option value="">ESCOLHA</option>
                            <option value="atendente">ATENDENTE</option>
                            <option value="caixa">CAIXA</option>
                            <option value="gerente">GERENTE</option>
                        </select>
                    </div>
                    <div class="input-content">
                        <label for="tipo_conta">Sexo</label>
                        <select name="sexo">
                            <option value="">ESCOLHA</option>
                            <option value="feminino">FEMININO</option>
                            <option value="masculino">MASCULINO</option>
                        </select>
                    </div>
                </div>
                <div class="content-separator">
                    <div class="input-content">
                        <label for="dataNasc">Data de nascimento</label>
                        <input type="date" name="dataNasc" placeholder="Preencher campo" required>
                    </div>
                    <div class="input-content">
                        <label for="salario">Salario</label>
                        <input type="text" name="salario" placeholder="Preencher campo" required>
                    </div>
                <div class="input-content">
                        <label for="id_agencia">ID Agencia</label>
                        <input type="text" name="id_agencia" placeholder="Preencher campo" required>
                    </div>
                    <div class="input-content">
                    </div>
                </div>
                <button type="submit" class="submit-btn">Confirmar cadastro</button>
            </form>
            <a class="back-btn" href="loginFunc.php">Voltar</a>
    </div>
</body>

</html>