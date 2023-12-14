<!DOCTYPE html>
<html lang="pt-BR">
<body>
    <main class="main">

        <button class="add-transaction" onclick="Modal.open()">Adicionar transação</button>

        <section class="cotent-area">
            <div class="subtitle-divider">
                <h3 class="subtitle">Transações</h3>
                
                <div class="scroll-area">
                    <div class="scroll-area">
                        <?php 
                             //pegando num_conta das contas da agência do caixa que está logado
                             $stmt = $conexao->prepare("SELECT num_conta FROM Contas WHERE agencia_id = '$agencia_id'");
                             if($stmt->execute()){
                                $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
                                foreach($retorno_consulta as $tupla){
                                    $num_conta = $tupla['num_conta'];
                    
                                    //pegando todas os atributos da tabela Transacao
                                    $stmt = $conexao->prepare("SELECT * FROM Transacao WHERE Contas_num_conta = $num_conta");
                                    if($stmt->execute()){
                                        $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
                                        foreach($retorno_consulta as $tupla){
                                            //armazenando as informações das transações em variáveis
                                            $num_transacao = $tupla['num_transacao'];
                                            $tipo_transacao = $tupla['tipo_transacao'];
                                            $data_hora = $tupla['data_hora'];
                                            $valor = $tupla['valor'];
                                            $num_conta_transacao = $tupla['Contas_num_conta']; ?>
                                            <div class="card">
                                                <div>
                                                    <h3 class="card-text">Nº conta</h3>
                                                    <p class="card-value"><?php echo $num_conta_transacao ?></p>
                                                </div>
                    
                                                <div>
                                                    <h3 class="card-text">Tipo</h3>
                                                    <p class="card-value"><?php echo $tipo_transacao ?></p>
                                                </div>
                    
                                                <div>
                                                    <h3 class="card-text">Valor</h3>
                                                    <p class="card-value"><?php echo $valor ?></p>
                                                </div>
                    
                                                <div>
                                                    <h3 class="card-text">Data</h3>
                                                    <p class="card-value"><?php echo $data_hora ?></p>
                                                </div>
                                            </div>
                        <?php }}}}?>
                    </div>
                </div>
            </div>
            
            <hr class="vertical-divider"/>

            <div class="subtitle-divider">
                <h3 class="subtitle">Contas</h3>
                
                <div class="scroll-area">
                    <div class="scroll-area">
                        <?php 
                             //pegando num_conta das contas da agência do caixa que está logado
                             $stmt = $conexao->prepare("SELECT num_conta, saldo, tipo_conta FROM Contas WHERE agencia_id = '$agencia_id'");
                             if($stmt->execute()){
                                $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
                                foreach($retorno_consulta as $tupla){
                                    $num_conta2 = $tupla['num_conta'];
                                    $saldo = $tupla['saldo'];
                                    $tipo_conta = $tupla['tipo_conta'];

                                    $tipo_conta2; //tratando o valor que vem do banco para uma melhor exibição
                                    if($tipo_conta === 'poupanca'){
                                        $tipo_conta2 = "Poupança";
                                    } else if($tipo_conta === 'especial'){
                                        $tipo_conta2 = "Especial";
                                    } else if($tipo_conta === 'corrente'){
                                        $tipo_conta2 = "Corrente";
                                    }
                                    
                                    //pegando o cpf do dono da conta em questão
                                    $stmt = $conexao->prepare("SELECT Clientes_cpf FROM Possui WHERE Contas_num_conta = $num_conta2");
                                    if($stmt->execute()){
                                        $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
                                        $cpf = $retorno_consulta[0]['Clientes_cpf'];

                                        //pegando o nome do dono da conta questão
                                        $stmt = $conexao->prepare("SELECT nome_completo FROM Clientes WHERE cpf = '$cpf'");
                                        if($stmt->execute()){
                                            $retorno_consulta = $stmt->fetchAll(PDO::FETCH_ASSOC);
                                            $nome_completo = $retorno_consulta[0]['nome_completo'];
                                        }
                                    } ?>
                                        
                                            <div class="card">
                                                <div>
                                                    <h3 class="card-text">Nº conta</h3>
                                                    <p class="card-value"><?php echo $num_conta2 ?></p>
                                                </div>
                    
                                                <div>
                                                    <h3 class="card-text">Usuário</h3>
                                                    <p class="card-value"><?php echo $nome_completo ?></p>
                                                </div>
                    
                                                <div>
                                                    <h3 class="card-text">Tipo</h3>
                                                    <p class="card-value"><?php echo $tipo_conta2 ?></p>
                                                </div>
                    
                                                <div>
                                                    <h3 class="card-text">Saldo</h3>
                                                    <p class="card-value"><?php echo $saldo ?></p>
                                                </div>
                                            </div>
                        <?php }}?>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <div class="modal-overlay">
        <div class="modal">
            <a class="close-modal" onclick="Modal.close()">Cancelar</a>
            <h2 class="form-title">Nova transação</h2>

            <form class="modal-form" action="../php/transacao_caixa.php" method="POST">
                <label for="num_conta" class="label-form">Numero da conta</label>
                <input type="text" name="num_conta" required>


                <label for="select_transacoes" class="label-form">Selecione um tipo de transação</label>
                <select name="select_transacoes" class="select_trancacoes" required>
                    <option id="opition_saque" value="saque">Saque</option>
                    <option id="opition_deposito" value="depósito">Depósito</option>
                    <option id="opition_transferencia" value="transferência">Transferência</option>
                    <option id="opition_estorno" value="estorno">Estorno</option>
                    <option id="opition_pagamento" value="pagamento">Pagamento</option>
                </select>

                <label for="valor_transacao" class="label-form">Informe o valor da transação</label>
                <small class="help">Valor em reais, ex: 200,00</small>
                <input type="text" name="valor_transacao" required>

                <button class="btn-submit-trasaction" type="submit">Confirmar</button>
            </form>
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
</body>
</html>