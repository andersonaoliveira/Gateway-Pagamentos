module ReturnCodesHelper
  def disapproval_codes
    [['00 - Cupom inválido.', '00'],
     ['01 - Transação não autorizada. Referida (suspeita de fraude) pelo banco emissor.', '01'],
     ['04 - Transação não autorizada. Cartão bloqueado pelo banco emissor.', '04'],
     ['08 - Transação não autorizada. Código de segurança inválido.', '08'],
     ['51 - Transação não autorizada. Limite excedido/sem saldo.', '51'],
     ['15 - Banco emissor indisponível ou inexistente.', '15']]
  end
end
