defmodule Listapp.EventsTest do
  use Listapp.DataCase

  alias Listapp.Events

  describe "events" do
    alias Listapp.Events.Event

    @valid_attrs %{
      date: ~D[2010-04-17],
      description: "some description",
      location: "some location",
      name: "some name"
    }
    @update_attrs %{
      date: ~D[2011-05-18],
      description: "some updated description",
      location: "some updated location",
      name: "some updated name"
    }
    @invalid_attrs %{date: nil, description: nil, location: nil, name: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.date == ~D[2010-04-17]
      assert event.description == "some description"
      assert event.location == "some location"
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.date == ~D[2011-05-18]
      assert event.description == "some updated description"
      assert event.location == "some updated location"
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "items" do
    alias Listapp.Events.Item

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Events.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Events.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Events.create_item(@valid_attrs)
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Events.update_item(item, @update_attrs)
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_item(item, @invalid_attrs)
      assert item == Events.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Events.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Events.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Events.change_item(item)
    end
  end

  describe "guests" do
    alias Listapp.Events.Guest

    @valid_attrs %{user_id: 1, event_id: 1}
    @update_attrs %{user_id: 2, event_id: 2}
    @invalid_attrs %{user_id: nil, event_id: nil}

    def guest_fixture(attrs \\ %{}) do
      {:ok, guest} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_guest()

      guest
    end

    test "list_guests/0 returns all guests" do
      guest = guest_fixture()
      assert Events.list_guests() == [guest]
    end

    test "get_guest!/1 returns the guest with given id" do
      guest = guest_fixture()
      assert Events.get_guest!(guest.id) == guest
    end

    test "create_guest/1 with valid data creates a guest" do
      assert {:ok, %Guest{} = guest} = Events.create_guest(@valid_attrs)
    end

    test "create_guest/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_guest(@invalid_attrs)
    end

    test "update_guest/2 with valid data updates the guest" do
      guest = guest_fixture()
      assert {:ok, %Guest{} = guest} = Events.update_guest(guest, @update_attrs)
    end

    test "update_guest/2 with invalid data returns error changeset" do
      guest = guest_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_guest(guest, @invalid_attrs)
      assert guest == Events.get_guest!(guest.id)
    end

    test "delete_guest/1 deletes the guest" do
      guest = guest_fixture()
      assert {:ok, %Guest{}} = Events.delete_guest(guest)
      assert_raise Ecto.NoResultsError, fn -> Events.get_guest!(guest.id) end
    end

    test "change_guest/1 returns a guest changeset" do
      guest = guest_fixture()
      assert %Ecto.Changeset{} = Events.change_guest(guest)
    end
  end
end
