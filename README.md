# EventHub-mobile

App Flutter do projeto **EventHub** (repositório principal no GitHub).

## Executar

```bash
cd EventHub-mobile
cp .env.example .env   # preencha com o app Web do Firebase Console
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

- Firebase Auth: **e-mail/senha** e **Google Sign-In**
- Acesso restrito a `@souunit.com.br` (logout imediato se domínio inválido)
- **Criar conta** e **Esqueci minha senha** integrados ao Firebase

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

| # | Tarefa | Responsável | Status | Prazo | Observações | Link do Vídeo de Defesa |
|---|--------|-------------|--------|-------|-------------|-------------------------|
| 1 | Tela de login, cadastro e esquecer senha | Hugo Machado | 🟢 | | telas de login, cadastro e recuperar senha; Firebase Auth e-mail/senha, `AuthGate`, `EnvConfig`, `.env.example`; tela Buscar com calendário; CRUD de eventos com imagem; **Google Sign-In**; validação `@souunit.com.br`; campo `usuario_logado` no Firestore; eventos salvos no Firestore; `firestore.rules`. | https://drive.google.com/file/d/1McxXfyknrNJZgWoeXr282knZD1S57t3G/view?usp=drive_link |
| 2 | Tela Home/Tela Criar Eventos | Cauê Vieira | 🟢 | 18/05 | — | — |
| 3 | Tela de Perfil | João Victor Gomes | 🟢 | | — | — |
| 4 | Tela Visualizar Eventos | Julia Souza | 🟢 | | tela visualizar evento (consumo do Firestore em tempo real); **Google Sign-In** via `signInWithPopup` do `firebase_auth`; validação de domínio `@souunit.com.br` em `auth_service.dart`; campo `criado_por` no Firestore com e-mail do usuário autenticado (`event_service.dart`). | https://drive.google.com/file/d/1i6WqDJO0crAUBMedbAkOovo3GPbvLQP2/view?usp=drive_link |

---

## Legenda de Status

| Ícone | Significado   |
|-------|---------------|
| 🔵    | A fazer       |
| 🟡    | Em andamento  |
| 🟢    | Concluído     |
| 🔴    | Bloqueado     |

---
