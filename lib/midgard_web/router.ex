defmodule MidgardWeb.Router do
  use MidgardWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MidgardWeb do
    pipe_through :api

    resources "/players", PlayerController, except: [:new, :edit]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :midgard, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Midgard"
      }
    }
  end
end
