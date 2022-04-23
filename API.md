## API

### Bandeira de cartão

#### Consulta bandeiras de cartão

**Requisição**

```
GET /gateway-pagamentos/api/v1/card_banners/
```

**Resposta**

```json
[
  {
  "name": "Visa",
  "max_tax": "10.0",
  "percentual_tax": "10.0",
  "max_instalments": "12",
  "discount": "10.0",
  },
  {
  "name": "MasterCard",
  "max_tax": "10.0",
  "percentual_tax": "10.0",
  "max_instalments": "12",
  "discount": "10.0",
  }
]
```
#### Consulta uma bandeira de cartão

**Requisição**

```
GET /gateway-pagamentos/api/v1/card_banners/id
```

**Resposta**

```json
  {
  "max_instalments": "12",
  }
```

### Cartão de crédito

#### Cadastrar cartão de crédito

**Requisição**

```
POST /gateway-pagamentos/api/v1/credit_cards/
```

**Parâmetros**

```json
{
  "holder_name": "Pedro de Lara",
  "cpf": "11111111111",
  "card_banner_id": 2,
  "number": "4444555566667777",
  "valid_date": "2024-01",
  "security_code": "222"
}
```

**Resposta**

```json
Status: 201 (Criado)

{ 
  "cpf": "11111111111",
  "token": "CAMPUSCODELOCAWEBQSD"
}
```
### Emissão de cobrança

#### Cadastrar cobrança

**Requisição**

```
POST /gateway-pagamentos/api/v1/charges/
```

**Parâmetros**

```json
{
  "id_order": 123,
  "product_group_id": "EMAIL",
  "order_value": 1000.0,
  "cupom_code": "NATAL20OFF-XU797",
  "client_eni": "11122233345",
  "credit_card_token": "QSDCAMPUSCODELOCAWEB",
  "qty_instalments": 10,
  "total_charge": 900.0
}
```

**Resposta**

```json
Status: 201 (Criado)

{ 
  "id": 45,
  "id_order": 123,
  "client_eni": "11122233345",
  "status": "pending"
}
```
### Cupon

#### Validar cupon e obter valor do desconto

**Requisição**

```
GET /api/v1/coupons/validate_coupon/?code=CUPONVALIDO-000001;product_group=Email;total=1000.0
```

**Parâmetros**

```json
{
  "code": "CUPONVALIDO-000001",
  "product_group": "Email",
  "total": "1000.0"
}
```

**Respostas**

***Cupon válido***

```json
Status: 200 (ok)

{ 
  "coupon": "válido",
  "discount": "100.0"
}
```

***Cupon inválido (não encontrado)***

```json
Status: 200 (ok)

{ 
  "coupon": "inválido",
  "error": "Cupom não encontrado"
}
```

***Cupon inválido (promoção expirada)***

```json
Status: 200 (ok)

{ 
  "coupon": "inválido",
  "error": "Promoção expirada"
}
```

***Cupon inválido (grupo de produtos inválido)***

```json
Status: 200 (ok)

{ 
  "coupon": "inválido",
  "error": "O cupom não é válido para este grupo de produtos"
}
```
