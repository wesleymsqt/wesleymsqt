<?php
// validando acesso e conectando ao banco
include_once("valida-acesso.php");
include('conexao.php');

if (isset($_POST['usuario']) && isset($_POST['senha'])) {
    $usuario = $_POST['usuario'];
    $senha = $_POST['senha'];

    if (empty($usuario)) {
        echo 'Preencha o usuário';
    } elseif (empty($senha)) {
        echo 'Preencha a senha';
    } else {
        // leva ao db4free
        if ($usuario === "Admin" && $senha === "Root") {
            header('Location: https://www.db4free.net/phpMyAdmin/index.php?route=/database/structure&db=equipe519388');
            exit;
        }

        $sql = "SELECT * FROM cliente WHERE cpf = :usuario AND senha = :senha";
        $stmt = $conexao->prepare($sql);
        $stmt->bindParam(':usuario', $usuario, PDO::PARAM_STR);
        $stmt->bindParam(':senha', $senha, PDO::PARAM_STR);
        $stmt->execute();

        $resultado = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($resultado) {
            // Iniciar a sessão apenas se não estiver iniciada
            if (session_status() == PHP_SESSION_NONE) {
                session_start();
            }
            
            $_SESSION['user'] = $resultado['cpf'];
            $_SESSION['senha'] = $resultado['senha'];
            $_SESSION['name'] = $resultado['nome'];
            $_SESSION['usuariocpf'] = $usuario;

            $_SESSION['autenticado'] = 'sim';
            
            header('Location: ../paginas/acessarConta.php');
            exit;
        } else {
            echo "Falha ao logar! CPF ou senha incorretos";
        }
    }
}
?>