<?php
    $servidor = 'db4free.net';
    $usuario = 'equipe519388';
    $senha = 'SenhaBDeq4';
    $dbname = 'equipe519388';

    //localhost caso seja necessário
    /*$servidor = 'db4free.net';
     $usuario = 'equipe519388';
     $senha = 'SenhaBDeq4';
     $dbname = 'equipe519388';*/

    $conexao = new PDO("mysql:host=$servidor;dbname=$dbname", "$usuario", "$senha");
?>