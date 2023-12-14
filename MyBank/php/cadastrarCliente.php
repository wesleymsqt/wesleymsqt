<?php
    include_once("conexao.php");

    //Pegando informações fornecidas na tela de login
    $email = $_POST['email'];
    $senha = md5($_POST['senha']);
    $tipoEmail = $_POST['tipoEmail'];
    $nome = $_POST['nome'];
    $dataNasc = $_POST['dataNasc'];
    $telefone = $_POST['telefone'];
    $tipoTelefone = $_POST['tipoTelefone'];
    $cpf = $_POST['cpf'];
    $rg = $_POST['rg'];
    $uf = $_POST['uf'];
    $orgao_emissor = $_POST['orgao_emissor'];
    $logradouro = $_POST['logradouro'];
    $nome_logradouro = $_POST['nome_logradouro'];
    $numero_casa = $_POST['num_casa'];
    $bairro = $_POST['bairro'];
    $cep = $_POST['cep'];
    $cidade = $_POST['cidade'];
    $estado = $_POST['estado'];

    // conectando ao banco e inserindo os dados
    $stmt = $conexao->prepare("INSERT INTO cliente VALUES('$cpf', '$senha','$nome', '$dataNasc', '$rg', '$orgao_emissor', 'uf')");

    if($stmt->execute()){
        $stmt = $conexao->prepare("INSERT INTO cliente_endereco VALUES ('$logradouro', '$nome_logradouro', '$numero_casa', '$bairro', '$cep', '$cidade', '$estado', '$cpf')");

        if($stmt->execute()){
            $stmt = $conexao->prepare("INSERT INTO clientes_emails VALUES ('$email', '$tipoEmail', '$cpf')");

            if($stmt->execute()){
                $stmt = $conexao->prepare("INSERT INTO cliente_telefone VALUES ('$telefone', '$tipoTelefone', '$cpf')");                

                if($stmt->execute()){
                    // se tudo der certo, ele volta a pag de login
                    header('Location: ../paginas/loginCliente.php');
                }
            }
        }
    }
?>