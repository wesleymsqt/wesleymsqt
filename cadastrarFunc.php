<?php
    include_once("conexao.php");

    //Pegando informações fornecidas pelo usuário na tela de cadastro
    $senha = md5($_POST['senha']);
    $nome = $_POST['nome'];
    $matricula = $_POST['matricula'];
 
    $endereco = $_POST['endereco'];
    $cidade = $_POST['cidade'];

    $salario = $_POST['salario'];
    $dataNasc = $_POST['dataNasc'];

    $id_agencia = $_POST['id_agencia'];
    $sexo = $_POST['sexo'];
    $cargo = $_POST['cargo'];

    // inserindo os dados no banco
    $stmt = $conexao->prepare("INSERT INTO funcionario VALUES(null ,'$matricula', '$nome','$senha', '$endereco', '$cidade', '$cargo', '$sexo', '$dataNasc', '$salario','$id_agencia')");

    if($stmt->execute()){
        // se inseririr corrertamente, volta a pag de inicio
        header('Location: ../paginas/loginFunc.php');
    }else{
        echo "Erro ao cadastrar";
    }

?>
