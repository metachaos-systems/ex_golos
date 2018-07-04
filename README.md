# English docs

ExGolos is an Elixir/Erlang library for HTTP/WS JSONRPC calls to Golos blockchain nodes.

## Installation

  1. Add `:ex_golos` to the list of dependencies  in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_golos, "~> 0.10"}]
    end
    ```

## Configuration

No configuration is required by default, ExGolos with use a default golos.io public node. To use a different node, configure `api_url` in your config.exs files.

## Documentation

Most functions are documented. Documentation is available on [hexdocs](https://hexdocs.pm/ex_golos/api-reference.html)

```elixir
config :ex_golos,
  api: :jsonrpc_http_api,
  api_url: System.get_env("GOLOS_API_URL"),
  activate_stage_sup: false
```

# Russian docs

# ExGolos

ExGolos -- это Elixir библиотека для взаимодействия с нодами блокчейна GOLOS с использованием JSONRPC протокола через HTTP/Websockets.

## Установка :ex_golos

  1. Добавьте `:ex_golos` в список зависимостей в `mix.exs`:

    ```elixir
    def deps do
      [{:ex_golos, "~> 0.10.0"}]
    end
    ```

## Конфигурация

ExGolos не требует конфигурации по умолчанию. Если конфигурация не задана, ExGolos будет использовать официальную публичную вебсокет API http://ws.golos.io для всех JSONRPC вызовов.

Если вы хотите использовать другой транспорт, общедоступную или приватную ноду, установите соответствующие значения для api и api_url. Возможные значения api: :jsonrpc_ws_api, :jsonrpc_http_api.

Если вы используете http или ws api, вам также нужно задать url ноды.

Для того, чтобы запустить стриминг ивентов используйте опцию конфинга `activate_stage_sup: true`.


```elixir
config :ex_golos,
  api: :jsonrpc_http_api,
  api_url: System.get_env("GOLOS_API_URL"),
  activate_stage_sup: false
```

В модуле присутствует стракты для каждого типа операции. Операции записанные в блоке обрабатываются и превращаются в соостветсвующий struct с известными ключами (которые можно посмотреть в документации).


## Пример использования

Главная функция в модуле: `Golos.call`. Вызов функции блокирует процесс до возврата success tuple с результатом или ошибкой, полученными в результате обработки JSONRPC вызов нодой. Id для JSONRPC вызовов задавать не надо, модуль их назначает и обрабатывает автоматически.

`Golos.call("database_api", "get_dynamic_global_properties", [])`

Такие функции API как `get_dynamic_global_properties` также блокируют процесс и возвращают success tuple. Информация о поддерживаемых функциях API находится в документации.

## GenStage

В ExGolos доступен интегрирован GenStage, [новый стандарт спецификации](http://elixir-lang.org/blog/2016/07/14/announcing-genstage/) для обработки и обмена ивентами между процессами Elixir/Erlang.

Все ивенты имеют форму `%Golos.Event{data: ..., metadata: ...}`, где значение `data` является страктом операции.

# Обработка ивентов

При запуске модуля активируются два GenStage процесса и регистрируется следующие имена:

* Golos.Stage.Blocks.производящий блоки
* Golos.Stage.RawOps получающий блоки и производящий необработанные операции
* Golos.Stage.MungedOps подписанный на RawOps и производящий обработанные и очищенные операции


## Пример GenStage consumer для обработки стрима операций

```
defmodule Golos.Stage.ExampleConsumer do
  use GenStage
  alias Steemex.MungedOps
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Example consumer is initializing...")
    {:consumer, state, subscribe_to: state[:subscribe_to]}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      process_event(op)
    end
    {:noreply, [], state}
  end

  def process_event(%{data: %MungedOps.Reblog{} = data, metadata: %{height: h, timestamp: t} = metadata}) do
      Logger.info """
      New reblog:
      #{inspect data}
      with metadata
      #{inspect metadata}
      """
  end

  def process_event(%{data: data, metadata: %{block_height: h, timestamp: t} = metadata}) do
      Logger.info """
      New operation:
      #{inspect data}
      with metadata
      #{inspect metadata}
      """
  end

end
```

## Дорожная карта


* Улучшить документацию
* Добавить оставшиеся стракты
* Добавить возможность броадкаста транзакций
