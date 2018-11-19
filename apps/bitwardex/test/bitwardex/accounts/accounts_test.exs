defmodule Bitwardex.AccountsTest do
  use Bitwardex.DataCase

  alias Bitwardex.Accounts

  describe "users" do
    alias Bitwardex.Accounts.Schemas.User

    @valid_attrs %{culture: "some culture", email: "test@foo.com", email_verified: true, kdf: 42, kdf_iterations: 42, key: "some key", master_password_hash: "some master_password_hash", master_password_hint: "some master_password_hint", name: "some name", premium: true}
    @update_attrs %{culture: "some updated culture", email: "updated_test@foo.com", email_verified: false, kdf: 43, kdf_iterations: 43, key: "some updated key", master_password_hash: "some updated master_password_hash", master_password_hint: "some updated master_password_hint", name: "some updated name", premium: false}
    @invalid_attrs %{culture: nil, email: nil, email_verified: nil, kdf: nil, kdf_iterations: nil, key: nil, master_password_hash: nil, master_password_hint: nil, name: nil, premium: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == {:ok, user}
    end

    test "get_user_by_email/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user_by_email(user.email) == {:ok, user}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.culture == "some culture"
      assert user.email == "test@foo.com"
      assert user.email_verified == true
      assert user.kdf == 42
      assert user.kdf_iterations == 42
      assert user.key == "some key"
      assert user.master_password_hash == "some master_password_hash"
      assert user.master_password_hint == "some master_password_hint"
      assert user.name == "some name"
      assert user.premium == true
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.culture == "some updated culture"
      assert user.email == "updated_test@foo.com"
      assert user.email_verified == false
      assert user.kdf == 43
      assert user.kdf_iterations == 43
      assert user.key == "some updated key"
      assert user.master_password_hash == "some updated master_password_hash"
      assert user.master_password_hint == "some updated master_password_hint"
      assert user.name == "some updated name"
      assert user.premium == false
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert {:ok, user} == Accounts.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
