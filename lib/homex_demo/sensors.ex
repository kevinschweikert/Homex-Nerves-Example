defmodule HomexDemo.TemperatureSensor do
  @moduledoc """
  A Homex.Entity for the BME690 sensors temperature values
  """

  use Homex.Entity.Sensor,
    name: "bme680 temp",
    device_class: "temperature",
    unit_of_measurement: "°C"

  def handle_timer(entity) do
    {:ok, measurements} = BMP280.measure(BME680)
    entity |> set_value(Float.round(measurements.temperature_c, 2))
  end
end

defmodule HomexDemo.HumiditySensor do
  @moduledoc """
  A Homex.Entity for the BME690 sensors humidity values
  """

  use Homex.Entity.Sensor,
    name: "bme680 hum",
    device_class: "humidity",
    unit_of_measurement: "%"

  def handle_timer(entity) do
    {:ok, measurements} = BMP280.measure(BME680)
    entity |> set_value(Float.round(measurements.humidity_rh, 2))
  end
end

defmodule HomexDemo.PressureSensor do
  @moduledoc """
  A Homex.Entity for the BME690 sensors pressure values
  """

  use Homex.Entity.Sensor,
    name: "bme680 press",
    device_class: "pressure",
    unit_of_measurement: "Pa"

  def handle_timer(entity) do
    {:ok, measurements} = BMP280.measure(BME680)
    entity |> set_value(Float.round(measurements.pressure_pa, 0))
  end
end


defmodule HomexDemo.CO2Sensor do
  @moduledoc """
  A Homex.Entity for the SGP30 sensors CO2 values
  """

  use Homex.Entity.Sensor,
    name: "sgp30_co2_eq_ppm",
    device_class: "carbon_dioxide",
    unit_of_measurement: "ppm"

  def handle_timer(entity) do
    %{co2_eq_ppm: co2_eq_ppm} = SGP30.state()
    entity |> set_value(co2_eq_ppm)
  end
end

defmodule HomexDemo.TVOCSensor do
  @moduledoc """
  A Homex.Entity for the SGP30 sensors TVOC values
  """

  use Homex.Entity.Sensor,
    name: "sgp30_tvoc_ppb",
    device_class: "volatile_organic_compounds_parts",
    unit_of_measurement: "ppb"

  def handle_timer(entity) do
    %{tvoc_ppb: tvoc_ppb} = SGP30.state()
    entity |> set_value(tvoc_ppb)
  end
end

defmodule HomexDemo.Relay do
  @moduledoc """
  A Homex.Entity for a relay.
  Uses `put_private/3` and `get_private/2` to keep the i2c bus handle in state and reference it
  """


  use Homex.Entity.Switch, name: "quiick_relay"

  def handle_init(entity) do
    {:ok, bus} = Circuits.I2C.open("i2c-1")
    entity |> put_private(:bus, bus) |> set_off()
  end

  def handle_on(entity) do
    bus = entity |> get_private(:bus)
    Circuits.I2C.write!(bus, 0x18, <<0x01>>)
    entity
  end

  def handle_off(entity) do
    bus = entity |> get_private(:bus)
    Circuits.I2C.write!(bus, 0x18, <<0x00>>)
    entity
  end
end

