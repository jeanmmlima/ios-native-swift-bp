# PaymentCard no Tap to Pay (iPhone) - Guia Prático

## 1. Visão geral
`PaymentCard` no contexto do `ProximityReader` é o fluxo de leitura NFC para transações presenciais no iPhone (Tap to Pay on iPhone), sem maquininha externa.

No app, o fluxo principal usa:
- `PaymentCardReader` (orquestrador do leitor)
- `PaymentCardReader.Token` (token curto vindo do PSP/backend)
- `PaymentCardReaderSession` (sessão ativa de leitura)
- `PaymentCardTransactionRequest` (valor/moeda/tipo da transação)
- `PaymentCardReadResult` (resultado da leitura)

---

## 2. O que vem do `ProximityReader` (objetos e sinais)

## 2.1 `PaymentCardReader`
Fornece:
- `isSupported`: indica se o dispositivo/sistema atual suporta Tap to Pay.
- `linkAccount(using:)`: vincula conta de processamento ao leitor.
- `isAccountLinked(using:)`: consulta se já está vinculada.
- `prepare(using:)`: cria uma sessão de leitura (`PaymentCardReaderSession`).
- `events`: stream assíncrono de eventos operacionais (`readyForTap`, `cardDetected`, `readCompleted`, etc.).

## 2.2 `PaymentCardReaderSession`
Fornece:
- `readPaymentCard(_ request: PaymentCardTransactionRequest)`: executa a leitura da transação.
- `cancelRead()`: cancela leitura em andamento.
- `ReadError`: erros detalhados da leitura (NFC desligado, sessão expirada, cancelamento, falha de leitura, etc.).

## 2.3 `PaymentCardTransactionRequest`
Entrada da operação:
- `amount` (`Decimal`)
- `currencyCode` (`String`, ex: `BRL`)
- `type` (`purchase` ou `refund`)

## 2.4 `PaymentCardReadResult`
Saída da operação:
- `id`: identificador da leitura no leitor.
- `paymentCardData`: payload de pagamento para envio ao PSP.
- `generalCardData`: dados gerais do cartão/dispositivo.
- `outcome` (`success`, `cardDeclined`, `failure`) em iOS mais recentes.
- outros campos opcionais por versão (PIN, estados de validade/expiração, etc.).

---

## 3. Ciclo operacional (fim a fim)

1. Backend solicita token ao PSP (sandbox ou produção).
2. App recebe esse token curto (`PaymentCardReader.Token`).
3. App valida suporte (`PaymentCardReader.isSupported`).
4. App garante vínculo de conta (`isAccountLinked`/`linkAccount`).
5. App abre sessão (`prepare(using:)`).
6. App monta request (`PaymentCardTransactionRequest`).
7. App inicia leitura (`session.readPaymentCard(request)`).
8. Durante a leitura, app acompanha eventos (`reader.events`) para UX.
9. App recebe `PaymentCardReadResult`.
10. App envia `paymentCardData`/`generalCardData` para backend.
11. Backend chama API do PSP para autorizar/capturar/confirmar.
12. App mostra status final para operador/cliente.

Observação: a leitura NFC no iPhone não substitui a autorização final no PSP. O backend continua sendo parte obrigatória.

---

## 4. O que é necessário na prática

## 4.1 Requisitos técnicos
- iPhone físico compatível (simulador não executa leitura NFC real).
- iOS compatível com a API usada.
- Framework `ProximityReader` no app.
- Capabilities/entitlements de Tap to Pay habilitados no Apple Developer.
- Assinatura/certificados e provisioning corretos.
- Chave `NFCReaderUsageDescription` no Info.plist.

## 4.2 Requisitos de negócio/integração
- Conta ativa em PSP/adquirente com suporte a Tap to Pay no iPhone.
- Ambiente sandbox para tokenização e testes.
- Endpoint backend para gerar token curto da sessão.
- Endpoint backend para processar `paymentCardData` no PSP.
- Regras de antifraude, confirmação de status e conciliação.

## 4.3 Requisitos operacionais
- Fluxo de erro robusto (`ReadError`, timeout, cancelamento, sessão expirada).
- Logs/telemetria para suporte.
- Estratégia de retry segura.
- Treinamento mínimo de operador para aproximação correta.

---

## 5. Exemplo de fluxo mínimo no app (alto nível)

1. Usuário informa valor.
2. App busca token no backend.
3. App chama `prepare(using:)`.
4. App chama `readPaymentCard(request)`.
5. App recebe `PaymentCardReadResult`.
6. App envia payload ao backend.
7. Backend confirma autorização com PSP.
8. App mostra "Aprovado", "Recusado" ou "Falha".

---

## 6. Erros comuns e diagnóstico rápido
- `isSupported == false`: ambiente sem suporte (simulador/dispositivo incompatível).
- Falha em `prepare`: token inválido/expirado, conta não habilitada ou sem entitlement.
- Falha em `readPaymentCard`: NFC indisponível, cancelamento, sessão expirada, leitura incompleta.
- `cardDeclined`: leitura ok, mas autorização recusada.

---

## 7. Sandbox vs produção
- O token de leitura sempre vem do PSP (não existe token "genérico" da Apple para todos PSPs).
- Token de sandbox costuma expirar rápido.
- Produção exige habilitação comercial e técnica completa (Apple + PSP + conta do merchant).

---

## 8. Checklist antes de testar em device real
- [ ] Entitlement de Tap to Pay ativo para o App ID.
- [ ] Build instalado em iPhone compatível.
- [ ] `NFCReaderUsageDescription` configurado.
- [ ] Backend gerando token sandbox válido.
- [ ] Fluxo backend aceitando payload do `PaymentCardReadResult`.
- [ ] Logs de erro e sucesso habilitados.

