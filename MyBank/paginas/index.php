<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BEM-VINDO</title>
    <link rel="stylesheet" href="../estilos/index.css">
    <link rel="stylesheet" href="../estilos/global.css">
</head>

<body>
    <div class="pageLogin">
        <form method="POST" class="formLogin" action="../php/entrarConta.php">
            <h1 class="title">Bem-vindo ao sistema NullBank</h1>
            <div class="subtitleLogin">EScolha em qual area voce deseja entrar:</div>
            <div class="content-separator">
                <div class="input-content">
                    <a class="login-btn" href="loginFunc.php">FUNCIONARIO</a>
                </div>
                <div class="input-content">
                    <a class="login-btn" href="loginCliente.php">CLIENTE</a>
                </div>
            </div>
        </form>
    </div>

</body>

</html>