# ExGolos

Scroll down for English version of this readme.

ExGolos -- это Elixir библиотека для взаимодействия с нодами GOLOS с использованием JSONRPC протокола по вебсокетам.

## Установка :ex_golos

  1. Добавьте `:ex_golos` в список зависимостей в `mix.exs`:

    ```elixir
    def deps do
      [{:ex_golos, "~> 0.5.0"}]
    end
    ```

  2. Добавьте ':golos' в список applications в `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :golos]]
    end
    ```

## Конфигурация

Сначала пропишите вебсокет урл для ноды Голоса в конфиг. Если ожидаете высокие нагрузки используйте собственную ноду, в ином случае подойдет публичная нода Голоса `wss://ws.golos.io`. Для удобства можно использовать ENV переменные, например, GOLOS_URL.

Для того, чтобы запустить стриминг ивентов используйте опцию конфинга `activate_stage_sup: true`.

```elixir
config :golos,
  url: System.get_env("GOLOS_URL"),
  activate_stage_sup: true
```

В модуле присутствует стракты для каждого типа операции. Операции записанные в блоке обрабатываются и превращаются в соостветсвующий struct с известными ключами (которые можно посмотреть в документации).

## GenStage

В ExGolos доступен интегрирован GenStage, [новый стандарт спецификации](http://elixir-lang.org/blog/2016/07/14/announcing-genstage/) для обработки и обмена ивентами между процессами Elixir/Erlang.

Все ивенты имеют форму `%Golos.Event{data: ..., metadata: ...}`, где значение `data` является страктом операции.

# Обработка ивентов

При запуске модуля активируются два GenStage процесса и регистрируется следующие имена:

* Golos.Stage.Blocks.производящий блоки
* Golos.Stage.RawOps получающий блоки и производящий необработанные операции
* Golos.Stage.MungedOps подписанный на RawOps и производящий обработанные и очищенные операции

## Пример использования

Главная функция в модуле: `Golos.call`. Вызов функции блокирует процесс до возврата success tuple с результатом или ошибкой, полученными в результате обработки JSONRPC вызов нодой. Id для JSONRPC вызовов задавать не надо, модуль их назначает и обрабатывает автоматически.

`Golos.call("database_api", "get_dynamic_global_properties", [])`

Такие функции API как `get_dynamic_global_properties` также блокируют процесс и возвращают success tuple. Информация о поддерживаемых функциях API находится в документации.

## Пример GenStage consumer для обработки стрима операций

```
defmodule Golos.Stage.Ops.ExampleConsumer do
  use GenStage
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    {:consumer, state, subscribe_to: state.subscribe_to}
  end

  def handle_events(events, _from, state) do
    for %{data: data, metadata: meta} <- events do
      Logger.info """
      New operation:
      #{inspect data}
      """
    end
    {:noreply, [], state}
  end

end
```

## Дорожная карта

ExGolos находится в активной разработке.

* ~~Исследовать использование GenStage~~
* Улучшить документацию
* Добавить оставшиеся стракты
* Добавить возможность броадкаста транзакций

# Golos

Elixir websockets client for interaction with GOLOS nodes. Provides an interface to Golos JSONRPC protocol. Golos is a supervised application, so don't forget to add it to applications in mix.exs.

## Installation

  1. Add `golos` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_golos, "~> 0.1.0"}]
    end
    ```

  2. Add 'golos' to applications in `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :golos]]
    end
    ```

## Example

First, configure a websockets url for the golosd instance, for example, `http://127.0.0.1:8090` to the config.

```elixir
config :golos,
  url: "GOLOS_URL"
```

The most imporant module function is `Golos.call`. It will block the calling process and return a success tuple with a "result" data from the JSONRPC call response. JSONRPC call ids are handled automatically.


## Roadmap

Golos is under active development.

* Add more types and structs
* Add more tests and docs
* Add transaction broadcast
