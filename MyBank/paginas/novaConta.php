<?php
    // validando acesso e conectando ao banco
    include_once('../php/valida-acesso.php');
    include_once('../php/conexao.php');

    //pegando cpf do cliente logado
    $cpf = $_SESSION['usuariocpf'];

?>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOVA CONTA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="../estilos/global.css">
    <link rel="stylesheet" href="../estilos/novaConta.css">
</head>

<body>
    <a class="back-btn" href="acessarConta.php">VOLTAR</a>

    <div class="page">
        <h1>Nova Conta</h1>
        <div class="container">
            <h3 class="subtitleLong">Agências Disponíveis</h3>
            <div class="content-separator">
                <!--AREA DE BUSCA -->
                <div class="scroll-area">
                    <?php
                        
                        $stmt = $conexao->prepare("SELECT agencia_id, nome_agencia, cidade FROM agencia
                         WHERE NOT EXISTS (SELECT cliente_CPF FROM conta WHERE AGENCIA_ID = agencia.agencia_id AND cliente_CPF = '$cpf')");
                        
                        if($stmt->execute()){
                            $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
                            foreach($retorno_consulta as $tupla){
                                $agencia_id = $tupla['agencia_id'];
                                $nome_agencia = $tupla['nome_agencia'];
                                $cidade = $tupla['cidade'];
                    ?>
                        
                                <div class="card">
                                    <div class="cardTexto">
                                        <label for="email">N° da Agencia: <?php echo $agencia_id ?> </label>
                                    </div>
                                    <div class="cardTexto">
                                        <label for="agencia">Nome Agencia: <?php echo $nome_agencia ?> </label>
                                    </div>

                                    <div class="cardTexto">
                                        <label for="localAgen">Local Agencia: <?php echo $cidade ?> </label>
                                    </div>
                                </div>
                    <?php   }
                        } ?>
                </div>
            </div>
        </div><br>
    </div>
    <!--AREA DE BUSCA DA CONTA -->       
    <div class="page">
        <div class="container">
            <div class="content-separator">
                <form method="POST" class="modal-form" action="../php/buscarConta.php">
                    <h3 class="subtitleLong">CADASTRE SUA CONTA</h3>
                    <div class="content-separator">
                        <label for="agencia_id">Numero da agencia</label>
                        <input type="text" name="agencia_id" placeholder="Preencher campo" required>

                        <label for="senha">Senha</label>
                        <input type="password" name="senha" id="senha" placeholder="******" required>
                        
                        <label for="tipo_conta">Tipo de conta</label>
                        <select name="tipo_conta">
                            <option>ESCOLHA</option>
                            <option value="poupanca">POUPANÇA</option>
                            <option value="corrente">CORRENTE</option>
                            <option value="especial">ESPECIAL</option>
                        </select>
                            
                        <label for="conta_conjunta">Conta conjunta?</label>
                        <select name="conta_conjunta">
                            <option>ESCOLHA</option>
                            <option value="unica">UNICA</option>
                            <option value="conjunta">CONJUNTA</option>
                        </select>
                        <button type="submit" class="submit-btn">CONFIRMAR</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>