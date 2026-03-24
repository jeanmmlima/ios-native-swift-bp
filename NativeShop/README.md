# NativeShop (iOS SwiftUI)

Conversão do exemplo Flutter para iOS nativo com:
- MVVM
- Observation (`@Observable`)
- `async/await` para chamadas assíncronas

## Estrutura
- `NativeShop/Models`: modelos de domínio
- `NativeShop/Services`: camada de serviço (chamada assíncrona)
- `NativeShop/ViewModels`: estado e regras de negócio
- `NativeShop/Views`: telas SwiftUI

## Abrir no Xcode
1. Descompacte o `.zip`.
2. Abra `NativeShop.xcodeproj` no Xcode.
3. Selecione um simulador/iPhone e execute.

## Observação
As chamadas assíncronas estão comentadas no código (`ProductService` e carregamento inicial da lista).
