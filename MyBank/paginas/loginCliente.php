<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOGIN</title>
    <link rel="stylesheet" href="../estilos/global.css">
    <link rel="stylesheet" href="../estilos/index.css">
</head>

<body>
    <a class="back-btn" href="index.php">VOLTAR</a>
    <div class="pageLogin">
        <form method="POST" class="formLogin" action="../php/entrarConta.php">
            <h1 style="text-align: center;" class="title">Login - NullBank</h1>
            <p>Digite os seus dados de acesso no campo abaixo.</p>
            <label for="usuario">Usuário</label>
            <input type="text" name="usuario" placeholder="Digite seu CPF" autofocus="true" required/>
            <label for="senha">Senha</label>
            <input type="password" name="senha" placeholder="Digite sua senha" required/>
            <a class="link-btn" href="cadastroCliente.php">Cadastre-se</a>
            <input type="submit" value="ACESSAR" class="submit-btn"/>
        </form>
    </div>
</body>
</html>