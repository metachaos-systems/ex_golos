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

```elixir
config :golos,
  url: System.get_env("GOLOS_URL"),
  stream_to: YourOpHandlerModule
```

Внимание: GenServer стриминга транзакций запускается при старте модуля ExGolos, если в настройках конфинга добавлен ключ `stream_to`. Процесс должен существовать, а имя процесса `YourOpHandlerModule` быть зарегистрированым.  

Альтернативой может быть запуск стримера вручную с помощью `Golos.Streamer.start_link(%{stream_to: YourOpHandlerModule})`

В модуле присутствует struct для каждого типа операции. Каждая операция на блокчейне обрабатывается и превращается в соостветсвующий struct с известными ключами (которые можно посмотреть в документации).

## Пример использования

Главная функция в модуле: `Golos.call`. Вызов функции блокирует процесс до возврата success tuple с результатом или ошибкой, полученными в результате обработки JSONRPC вызов нодой. Id для JSONRPC вызовов задавать не надо, модуль их назначает и обрабатывает автоматически.

`Golos.call("database_api", "get_dynamic_global_properties", [])`

Такие функции API как `get_dynamic_global_properties` также блокируют процесс и возвращают success tuple. Информация о поддерживаемых функциях API находится в документации.

## Пример использования модуля для обработки стрима операций

```
defmodule Golos.OpsHandlerExample do
  use GenServer
  require Logger

  @doc"""
  Starts the handler module
  """
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(config \\ %{}) do
    {:ok, config}
  end

  def handle_info({:comment, data}, state) do
    Logger.info("Новый пост или комментарий:  #{inspect(data)}" )
    {:noreply, state}
  end

  def handle_info({:vote, data}, state) do
    Logger.info("Новый голос:  #{inspect(data)}" )
    {:noreply, state}
  end


  def handle_info({op_type, op_data}, state) do
    Logger.info("Новая операция #{op_type}:  #{inspect(op_data)}" )
    {:noreply, state}
  end


end
```

## Дорожная карта

ExGolos находится в активной разработке.

* Исследовать использование GenStage
* Добавить функции для всех типов вызвовов
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

* Implement subscriptions
* Investigate using GenStage
* Add more utility functions
* Add more types and structs
* Add more tests and docs
* Add transaction broadcast
