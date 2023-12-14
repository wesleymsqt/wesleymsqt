<?php

    include_once('../php/valida-acesso.php');
    include_once('../php/conexao.php');

    $numConta = $_SESSION['numContaGlobal'];
    $saldoConta= $_SESSION['saldoGlobal'];
    $nome = $_SESSION['name'];
?>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRANSAÇÃO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    
    <link rel="stylesheet" href="../estilos/novaConta.css">
    <link rel="stylesheet" href="../estilos/global.css">
</head>

<body>
    <a class="back-btn" href="acessarConta.php">VOLTAR</a>

    <div class="page">
        <h1>Nullbank</h1>
        <div class="container">
            <h3 class="subtitleLong">Dados da sua conta</h3>
            <div class="content-separator">
                <div class="input-content">
                    <label for="usuario">Usuario: <?php echo $nome ?></label>
                </div>
                <div class="input-content">
                    <label for="saldo">Saldo: <?php echo $saldoConta  ?></label>
                </div>
            </div>
        </div>
    </div><br>
    <div class="page">
        <div class="container">
            <h3 class="subtitleLong">Escolha a operação</h3>
            <div class="content-separator">
                <div class="input-content">
                    <button type="submit" class="submit-btn">SAQUE</button>
                </div>
                <div class="input-content">
                    <button type="submit" class="submit-btn">DEPOSITO</button>
                </div>
            </div>
            <div class="content-separator">
                <div class="input-content">
                    <button type="submit" class="submit-btn">TRANSFERÊNCIA</button>
                </div>
                <div class="input-content">
                    <button type="submit" class="submit-btn">ESTORNO</button>
                </div>
            </div>
        </div>
    </div>

</body>

</html>