defmodule ExMonWeb.Router do
  use ExMonWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ExMonWeb do
    pipe_through(:api)
    resources("/trainers", TrainersController, only: [:create, :show, :delete, :update])

    resources("/trainer_pokemons", TrainerPokemonsController,
      only: [:create, :show, :delete, :update]
    )

    get("/pokemons/:name", PokemonsController, :show)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ex_mon, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: ExMonWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  scope "/", ExMonWeb do
    pipe_through(:api)

    get("/", WelcomeController, :index)
  end
end
