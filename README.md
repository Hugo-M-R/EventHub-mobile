# EventHub-mobile

App Flutter do projeto **EventHub** (repositório principal no GitHub).

## Executar

```bash
cd EventHub-mobile
flutter pub get
flutter run
```

Web (navegador): `flutter run -d chrome`

Com Docker (na pasta `EventHub-mobile`):

```bash
docker compose up web
```

Abra `http://localhost:8080`.

**Ver mudanças no código (sem `r` no teclado):**

1. Salve o arquivo `.dart` — com hot reload experimental, o navegador pode atualizar sozinho após alguns segundos.
2. Se não atualizar: **Ctrl+Shift+R** no navegador (recarregar forçado).
3. Ainda assim antigo: em outro terminal, `docker compose restart web` (reinicia o servidor Flutter).

Para tentar `r` / `R` no terminal: suba só o serviço web em modo interativo:

```bash
docker compose run --rm -it --service-ports web
```

(O `docker compose up` mistura logs de vários containers e o `r` costuma não chegar ao Flutter.)

## Tela de login (implementada)

- Login com qualquer e-mail (senha não validada)
- **Criar conta** e **Esqueci minha senha** → telas completas (sem validação de backend)

---

# Divisão de Tarefas — Eventhub

## Informações Gerais

| Campo        | Detalhe                  |
|--------------|------------------------- |
| Projeto      | EventHub                 |
| Período      | 02/2026 a 06/2026        |
| Disciplina   | Prog-Dispositivos-Moveis |

---

## Tabela de Tarefas

| # | Tarefa | Responsável | Status | Prazo | Observações |
|---|--------|-------------|--------|-------|-------------|
| 1 | Tela de login, cadastro e esquecer senha | Hugo Machado | 🟡 | | Login implementado; cadastro e recuperar senha em breve |
| 2 | Tela Home/Tela Criar Eventos | Cauê Vieira | 🔵 | 18/06 | — |
| 3 | Tela de Perfil | João Victor Gomes | 🔵 | | — |
| 4 | Tela Visualizar Eventos | Julia Souza | 🔵 | | — |

---

## Legenda de Status

| Ícone | Significado   |
|-------|---------------|
| 🔵    | A fazer       |
| 🟡    | Em andamento  |
| 🟢    | Concluído     |
| 🔴    | Bloqueado     |

---
