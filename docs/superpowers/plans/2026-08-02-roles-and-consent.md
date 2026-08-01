# Roles and Consent Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Согласовать роли Жуковой Анны Владимировны и Александра Прохорова во всех публичных документах и добавить явное согласие в форму заявки.

**Architecture:** Сайт остаётся статическим. Тексты ролей меняются непосредственно в трёх юридических HTML-документах, а контракт формы — в `index.html`; отдельный PowerShell-тест проверяет согласованность терминов и обязательные атрибуты формы.

**Tech Stack:** HTML5, CSS, vanilla JavaScript, PowerShell, существующий Cloudflare Worker без изменений.

## Global Constraints

- Жукова Анна Владимировна — исполнитель, плательщик НПД, получатель оплаты и оператор персональных данных.
- Александр Прохоров — специалист и контактное лицо, обрабатывающее заявки и выполняющее работы от имени исполнителя.
- Причина распределения ролей нигде не публикуется.
- Адрес Cloudflare Worker и формат существующей заявки не меняются.
- Тексты не заявляют юридическую сертификацию или гарантированное соответствие законодательству.

---

### Task 1: Автоматическая проверка ролей и формы

**Files:**
- Create: `tools/check-legal-roles.ps1`
- Test: `index.html`, `offer.html`, `privacy.html`, `confidentiality.html`

**Interfaces:**
- Consumes: статические HTML-файлы в корне репозитория.
- Produces: exit code `0` при согласованных ролях и форме; exit code `1` со списком нарушенных условий.

- [ ] **Step 1: Создать проверку, которая сначала падает**

Скрипт читает файлы через `Get-Content -Raw -Encoding UTF8` и проверяет следующие пары файл/шаблон:

```powershell
$checks = @(
  @{ File = 'offer.html'; Pattern = 'Александр Прохоров.*от имени Исполнителя' },
  @{ File = 'privacy.html'; Pattern = 'Оператор.*Жукова Анна Владимировна' },
  @{ File = 'privacy.html'; Pattern = 'Александр Прохоров.*от имени Оператора' },
  @{ File = 'confidentiality.html'; Pattern = 'Исполнитель.*Жукова Анна Владимировна' },
  @{ File = 'index.html'; Pattern = 'name="consent"' },
  @{ File = 'index.html'; Pattern = 'name="contact"' }
)
```

При любой ошибке вывести её и завершить работу через `exit 1`; иначе вывести `OK`.

- [ ] **Step 2: Подтвердить ожидаемое падение**

Run: `powershell -ExecutionPolicy Bypass -File tools/check-legal-roles.ps1`

Expected: `FAIL` для отсутствующего согласия и несогласованных определений.

- [ ] **Step 3: Зафиксировать тест**

```powershell
git add tools/check-legal-roles.ps1
git commit -m "test: add legal roles and consent contract"
```

### Task 2: Согласовать публичную оферту

**Files:**
- Modify: `offer.html:250-265`
- Modify: `offer.html:512-525`
- Modify: `offer.html:578-586`

**Interfaces:**
- Consumes: утверждённое распределение ролей.
- Produces: единое определение Исполнителя, контактного лица, оплаты и обработки данных.

- [ ] **Step 1: Обновить определения сторон**

Определить Жукову Анну Владимировну как Исполнителя, плательщика НПД и получателя оплаты. Определить Александра Прохорова как специалиста и контактное лицо, которое от имени Исполнителя ведёт коммуникацию, разрабатывает и сопровождает проекты.

- [ ] **Step 2: Согласовать персональные данные**

Использовать название `Федеральный закон № 152-ФЗ «О персональных данных»`. Указать Жукову А. В. оператором, а Александра Прохорова — лицом, обрабатывающим обращения от имени оператора для ответа, подготовки предложения, исполнения заказа и сопровождения.

- [ ] **Step 3: Проверить реквизиты и тест**

Сохранить ИНН `910609523008`. Запустить `powershell -ExecutionPolicy Bypass -File tools/check-legal-roles.ps1`; проверки оферты должны пройти.

- [ ] **Step 4: Зафиксировать оферту**

```powershell
git add offer.html
git commit -m "docs: clarify service provider roles in offer"
```

### Task 3: Согласовать политики

**Files:**
- Modify: `privacy.html:20-105`
- Modify: `confidentiality.html:20-82`

**Interfaces:**
- Consumes: определения из Task 2.
- Produces: единые роли оператора данных, владельца сайта и лица, работающего с обращениями.

- [ ] **Step 1: Обновить политику обработки данных**

Добавить точные определения:

```text
Оператор персональных данных — Жукова Анна Владимировна, плательщик НПД, ИНН 910609523008.
Александр Прохоров обрабатывает обращения и взаимодействует с пользователями от имени Оператора.
```

Сохранить фактические цели, категории данных, сервисы, отзыв согласия и контакт `prohar2f@gmail.com`.

- [ ] **Step 2: Обновить политику конфиденциальности**

Определить Александра Прохорова владельцем/автором сайта и рабочим контактным лицом; Жукову Анну Владимировну — Исполнителем и оператором. Добавить ссылку на `privacy.html` в раздел обработки данных.

- [ ] **Step 3: Запустить тест и зафиксировать политики**

Run: `powershell -ExecutionPolicy Bypass -File tools/check-legal-roles.ps1`

```powershell
git add privacy.html confidentiality.html
git commit -m "docs: align privacy roles across policies"
```

### Task 4: Добавить контракт и согласие формы

**Files:**
- Modify: `index.html:682-694`
- Modify: `index.html:1713-1746`
- Modify: `index.html:1788-1950`

**Interfaces:**
- Consumes: DOM-id `orderForm`, `submitBtn`, `formWrap` и `WORKER_URL`.
- Produces: поля `name`, `contact`, `email`, `service`, `comment`, `consent`; проверка согласия до сетевого запроса.

- [ ] **Step 1: Добавить имена полей**

Добавить `name="name"`, `name="contact"`, `name="email"`, `name="service"`, `name="comment"`, сохранив существующие `id` и селекторы.

- [ ] **Step 2: Добавить обязательное согласие**

Перед кнопкой добавить checkbox `id="fconsent" name="consent" required` со связанной подписью. Сообщить, что Жукова А. В. является оператором, а Александр Прохоров обрабатывает заявку от её имени. Добавить ссылки `privacy.html` и `offer.html`.

- [ ] **Step 3: Добавить доступные стили**

Добавить классы строки согласия, читаемых ссылок и видимого `:focus-visible` без inline-обработчика checkbox.

- [ ] **Step 4: Проверить согласие до отправки**

До `fetch` вызвать `form.checkValidity()`; при `false` вызвать `form.reportValidity()` и завершить обработчик. Существующую отправку и экран успеха не менять.

- [ ] **Step 5: Запустить тест и зафиксировать форму**

Run: `powershell -ExecutionPolicy Bypass -File tools/check-legal-roles.ps1`

Expected: `OK`.

```powershell
git add index.html
git commit -m "feat: add explicit consent to contact form"
```

### Task 5: Полная регрессия

**Files:**
- Verify: `index.html`, `offer.html`, `privacy.html`, `confidentiality.html`
- Verify: `tools/check-legal-roles.ps1`, `tools/check-local-links.ps1`, `tools/check-vizual-case.ps1`

**Interfaces:**
- Consumes: результаты Tasks 1–4.
- Produces: проверенный комплект статических файлов, готовый к отдельному развёртыванию.

- [ ] **Step 1: Запустить три проверки**

```powershell
powershell -ExecutionPolicy Bypass -File tools/check-legal-roles.ps1
powershell -ExecutionPolicy Bypass -File tools/check-local-links.ps1
powershell -ExecutionPolicy Bypass -File tools/check-vizual-case.ps1
```

Expected: три успешных завершения.

- [ ] **Step 2: Разобрать HTML стандартным парсером**

Run:

```powershell
python -c "from html.parser import HTMLParser; from pathlib import Path; p=HTMLParser(); [p.feed(Path(f).read_text(encoding='utf-8')) for f in ['index.html','offer.html','privacy.html','confidentiality.html']]; p.close(); print('OK')"
```

Expected: `OK`.

- [ ] **Step 3: Проверить рабочее дерево**

Run: `git status --short` and `git diff --check`

Expected: отсутствуют незакоммиченные изменения и ошибки пробелов.
