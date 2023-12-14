<?php
    // validando acesso e conectando ao banco
    include_once('../php/valida-acesso.php');
    include_once('../php/conexao.php');


    //pegando cpf do cliente que foi digitado na tela de login
    $cpf = $_SESSION['usuariocpf'];


    //atribuindo os os dados do cliente
    $tipo_conta = $_POST['tipo_conta'];
    $conta_conjunta =  $_POST['conta_conjunta'];
    $agencia_id = (int) $_POST['agencia_id'];
    $senha = md5($_POST['senha']);
    $numConta = random_int(10000, 99999);

    //verificando se a agência informada existe no banco
    $stmt = $conexao->prepare("SELECT COUNT(*) AS num FROM agencia WHERE agencia_id = '$agencia_id'");
    if($stmt->execute()){
        $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $valor = (int) $retorno_consulta[0]['num'];
        if($valor === 0){

            echo "<script>alert('Agencia não encontrada');</script>";
            header('Location: ../paginas/novaConta.php?agencia_id=erro');
        }
    }

    //verificando se o cpf informado já existe em uma conta na mesma agencia
    $stmt = $conexao->prepare("SELECT COUNT(numConta) AS num FROM conta WHERE cliente_CPF = '$cpf' AND AGENCIA_ID = '$agencia_id'");
    if($stmt->execute()){
        $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $valor = $retorno_consulta[0]['num'];
        if($valor > 0){
            echo "<script>alert('Já possui uma conta nessa agência');</script>";

            header('Location: ../paginas/novaConta.php?agencia_id=erro');
        } else {
            //inserindo a nconta no banco de dados
            $stmt = $conexao->prepare("INSERT INTO conta(numConta, saldo, senha, tipo_conta, conta_unica_conjunta, AGENCIA_ID, funcionario_id, cliente_CPF)
            VALUES('$numConta', '0.00', '$senha', '$tipo_conta', '$conta_conjunta', '$agencia_id', null,'$cpf')"); //'$matricula_gerente' gerente_matricula
            if($stmt->execute()){

                echo "<script>alert('Conta inserida com sucesso');</script>";
                echo "<script>alert('Numero da conta: $numConta; Senha: $senha');</script>";

                header('Location: ../paginas/acessarConta.php?numConta='.$numConta.'&senha='.$senha.'');


            }else{
                echo "<script>alert('Erro ao criar a conta');</script>";
                header('Location: ../paginas/acessarConta.php');
            }
            
        }
    }
?>