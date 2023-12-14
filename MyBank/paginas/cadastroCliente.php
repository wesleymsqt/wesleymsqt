<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CADASTRO CLIENTE</title>
    <link rel="stylesheet" href="../estilos/global.css">
    <link rel="stylesheet" href="../estilos/cadastro.css">
</head>

<body>
    
    <div class="page">
    <form class="formCad" method="POST" action="../php/cadastrarCliente.php">
            <h3 class="subtitle">Informações para cadastro</h3>
            <div class="content-separator">
                <div class="input-content">
                    <label for="email">Email</label>
                    <input type="email" name="email" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="senha">Senha</label>
                    <input type="password" name="senha" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="tipoEmail">Tipo do email</label>
                    <input type="text" name="tipoEmail" placeholder="Ex: Particular, comercial, etc..." required>
                </div>

                <div class="input-content">
                    <label for="nome">Nome completo</label>
                    <input type="text" name="nome" placeholder="Preencher campo" required>
                </div>
                
                <div class="input-content">
                    <label for="dataNasc">Data de nascimento</label>
                    <input type="date" name="dataNasc" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="telefone">Telefone</label>
                    <input type="text" name="telefone" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="TipoTelefone">Tipo de Telefone</label>
                    <input type="text" name="tipoTelefone" placeholder="Ex: residencial, comercial, celular1, celular2 , etc..." required>
                </div>
            </div>
            
            <h3 class="subtitle">Documentos</h3>
            <div class="content-separator">
                <div class="input-content">
                    <label for="cpf">CPF</label>
                    <input type="text" name="cpf" maxlength="11" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="rg">RG</label>
                    <input type="text" name="rg" maxlength="11" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="uf">UF</label>
                    <input type="text" name="uf" maxlength="2" placeholder="Preencher campo" required>
                </div>
                
                <div class="input-content">
                    <label for="orgao_emissor">Orgão emissor</label>
                    <input type="text" name="orgao_emissor" placeholder="Preencher campo" required>
                </div>
            </div>

            <h3 class="subtitle">Endereço</h3>
            <div class="content-separator endereco">
                <div class="input-content">
                    <label for="logradouro">Tipo de logradouro</label>
                    <input type="text" name="logradouro" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="nome_logradouro">Nome do logradouro</label>
                    <input type="text" name="nome_logradouro" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="num_casa">Número</label>
                    <input type="text" name="num_casa" placeholder="Preencher campo" required>
                </div>
                
                <div class="input-content">
                    <label for="bairro">Bairro</label>
                    <input type="text" name="bairro" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="cep">CEP</label>
                    <input type="text" name="cep" placeholder="Preencher campo" required>
                </div>
                
                <div class="input-content">
                    <label for="cidade">Cidade</label>
                    <input type="text" name="cidade" placeholder="Preencher campo" required>
                </div>

                <div class="input-content">
                    <label for="estado">Estado</label>
                    <input type="text" name="estado" placeholder="Preencher campo" required>
                </div>
            </div>
            <button type="submit" class="submit-btn">Confirmar cadastro</button>
        </form>
        <a class="back-btn" href="loginCliente.php">Voltar</a>
    </div>
</body>

</html>