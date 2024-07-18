defmodule Kiltercrew.DatabaseSync do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(_opts) do
    {:ok, curr_dir} = File.cwd()
    db_path = Path.join(curr_dir, "/assets/database/assets/db.sqlite3")

    if !File.exists?(db_path) do
      IO.puts("get the db")
      get_db()
    end

    IO.puts("nothing nothing")
    {:ok, nil}
  end

  def get_db do
    app_package_names = %{
      "aurora" => "auroraboard",
      "decoy" => "decoyboard",
      "grasshopper" => "grasshopperboard",
      "kilter" => "kilterboard",
      "tension" => "tensionboard2",
      "touchstone" => "touchstoneboard"
    }

    url = "https://d.cdnpure.com/b/APK/com.auroraclimbing.#{app_package_names["kilter"]}?version=latest"

    Req.get(
      url,
      headers: [{"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"}]
    )
    |> case do
      {:ok, response} ->
        {:ok, curr_dir} = File.cwd()
        db_path = Path.join(curr_dir, "/assets/database")

        :zip.unzip(response.body, cwd: db_path, file_list: [~c"assets/db.sqlite3"])

        {:ok, nil}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
