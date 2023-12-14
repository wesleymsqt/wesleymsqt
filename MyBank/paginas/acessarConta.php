<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ACESSAR CONTA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="../estilos/global.css">
    <link rel="stylesheet" href="../estilos/cadastro.css">
</head>

<body>
    <a class="back-btn" href="index.php">VOLTAR</a>
    <a class="novaConta" href="novaConta.php">NOVA CONTA</a>

    <!-- PEGANDO OS DADOS DA CONTA -->
    <div class="page">
        <h1>Contas cadastradas</h1>
        <form class="formCad" method="GET">
            <h3 class="subtitleLong">Informe os dados da conta</h3>
            <div class="content-separator">
                <div class="input-content">
                    <label for="numConta">Numero da conta</label>
                    <input type="text" name="numConta" id="numConta" placeholder="Informe o numero da conta" required>
                </div>
                <div class="input-content">
                    <label for="senha">Senha</label>
                    <input type="password" id="senha" name="senha" placeholder="******" required>
                </div>
            </div>
            <div class="content-separator">
                <div class="input-content">
                    <button type="submit" class="submit-btn">BUSCAR</button>
                </div>
            </div>
            <div class="content-separator">
                <div class="input-content">
                </div>
            </div>
        </form>
    </div><br>
    <!-- MODAL DE TRANSAÇÃO -->
    <div class="modal-overlay">
            <div class="modal">
                <a class="close" onclick="Modal.close()">Cancelar</a>
                <h1 class="form-title">Informações</h1>
                <form class="modal-form" method="POST" action="../php/buscarConta.php">
                    <label for="agencia_id">Numero da agencia</label>
                    <input type="text" name="agencia_id" placeholder="Preencher campo" required>
                    <label for="senha">Senha</label>
                    <input type="password" name="senha" id="senha" placeholder="******" required>
                </form>
                <a class="submit-btn" href="transacao.php">NOVA CONTA</a>
            </div>
        </div>
        <script>
        const Modal = {
            open(){
                document
                    .querySelector(".modal-overlay")
                    .classList
                    .add("active")
            },
            close(){
                document
                    .querySelector(".modal-overlay")
                    .classList
                    .remove("active")
            }
        }
        </script>

     <!-- MOSTRANDO OS DADOS -->
    <h1>Dados da conta</h1>
    <div class="container">
    <?php
        include('../php/valida-acesso.php');
        include('../php/conexao.php');

        // Verificar se o ID e a senha estão definidos
        if (isset($_GET['numConta']) && isset($_GET['senha'])) {
            $user_numConta = $_GET['numConta'];
            $user_senha = $_GET['senha'];

                // Consultar o banco de dados para verificar se o ID e a senha correspondem
                $sql_verificar = "SELECT * FROM conta WHERE numConta = :user_numConta AND senha = :user_senha";
                $stmt_verificar = $conexao->prepare($sql_verificar);
                $stmt_verificar->bindParam(':user_numConta', $user_numConta, PDO::PARAM_INT);
                $stmt_verificar->bindParam(':user_senha', $user_senha, PDO::PARAM_STR);
                $stmt_verificar->execute();

                $resultado_verificar = $stmt_verificar->fetch(PDO::FETCH_ASSOC);

                if ($resultado_verificar) {
                    // Se a verificação for bem-sucedida, exibir a conta correspondente
                    $sql_conta = "SELECT * FROM conta WHERE numConta = :user_numConta";
                    $stmt_conta = $conexao->prepare($sql_conta);
                    $stmt_conta->bindParam(':user_numConta', $user_numConta, PDO::PARAM_INT);
                    $stmt_conta->execute();

                    $resultados = $stmt_conta->fetchAll(PDO::FETCH_OBJ);
                    $qtd = count($resultados);

                    if ($qtd > 0) {
                        print "<table class='table table-hover table-striped table-bordered' style='width: 100%; margin: 0 auto; border-radius: 10px;'>";
                        print "<tr>";
                        print "<th>Numero</th>";
                        print "<th>Saldo</th>";
                        print "<th>Tipo</th>";
                        print "<th>Unica ou Conjunta</th>";
                        print "<th>CPF</th>";
                        print "<th>Açoes</th>";
                        print "</tr>";
                        foreach ($resultados as $row) {
                            $_SESSION['numContaGlobal'] = $row->numConta;
                            $_SESSION['saldoGlobal'] = $row->saldo;
                            $_SESSION['tipoContaGlobal'] = $row->tipo_conta;
                            $_SESSION['contaUnicaConjuntaGlobal'] = $row->conta_unica_conjunta;
                            $_SESSION['clienteCPFGlobal'] = $row->cliente_CPF;
                            print "<tr>";
                            print "<td>" . $row->numConta . "</td>";
                            print "<td>" . $row->saldo . "</td>";
                            print "<td>" . $row->tipo_conta . "</td>";
                            print "<td>" . $row->conta_unica_conjunta . "</td>";
                            print "<td>" . $row->cliente_CPF . "</td>";
                            print "<td><button onclick=\"window.location.href='transacao.php'\" class='submit-btn'>Transação</button></td>";
                            print "</tr>";
                        }
                        print "</table>";
                    } else {
                        print "<p class='alert alert-danger'>Não encontrou resultados.</p>";
                    }
                } else {
                    print "<p class='alert alert-danger'>ID ou senha incorretos.</p>";
                }
            } else {
                print "<p class='alert alert-danger st' style='color: black; background-color: #c5a6f8; width: 50%; margin: 0 auto;'> INSIRA O NUMERO DA CONTA E A SENHA.</p>";
            }
        ?>
    </div>
</body>

</html>