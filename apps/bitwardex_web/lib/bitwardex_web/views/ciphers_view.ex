defmodule BitwardexWeb.CiphersView do
  use BitwardexWeb, :view

  alias Bitwardex.Core
  alias Bitwardex.Core.Schemas.Cipher
  alias Bitwardex.Core.Schemas.CipherFolder
  alias Bitwardex.Core.Schemas.Ciphers.Card
  alias Bitwardex.Core.Schemas.Ciphers.Identity
  alias Bitwardex.Core.Schemas.Ciphers.Login
  alias Bitwardex.Core.Schemas.Ciphers.SecureNote
  alias Bitwardex.Core.Schemas.Field

  def render("cipher.json", %{current_user: user, cipher: %Cipher{} = cipher}) do
    folder_id =
      case Core.get_cipher_folder(cipher, user) do
        {:ok, %CipherFolder{folder_id: folder_id}} -> folder_id
        _ -> nil
      end

    base_struct = %{
      "Name" => cipher.name,
      "FolderId" => folder_id,
      "Favorite" => cipher.favorite,
      "Edit" => true,
      "Id" => cipher.id,
      "OrganizationId" => cipher.organization_id,
      "CollectionIds" => Enum.map(cipher.collections, & &1.id),
      "Type" => cipher.type,
      "Notes" => cipher.notes,
      "Fields" => Enum.map(cipher.fields, &render_field/1),
      "Attachments" => [],
      "OrganizationUseTotp" => false,
      "RevisionDate" => NaiveDateTime.to_iso8601(cipher.updated_at),
      "Object" => "cipher"
    }

    case cipher.type do
      1 -> Map.put(base_struct, "Login", render_login(cipher.login))
      2 -> Map.put(base_struct, "SecureNote", render_secure_note(cipher.secure_note))
      3 -> Map.put(base_struct, "Card", render_card(cipher.card))
      4 -> Map.put(base_struct, "Identity", render_identity(cipher.identity))
      _ -> base_struct
    end
  end

  defp render_field(%Field{} = field) do
    %{
      "Name" => field.name,
      "Value" => field.value,
      "Type" => field.type
    }
  end

  defp render_login(%Login{} = login) do
    login_uris_json =
      Enum.map(login.uris, fn uri ->
        %{
          "Match" => uri.match,
          "Uri" => uri.uri
        }
      end)

    %{
      "Username" => login.username,
      "Password" => login.password,
      "PasswordRevisionDate" => login.password_revision_date,
      "Totp" => login.totp,
      "Uris" => login_uris_json
    }
  end

  defp render_identity(%Identity{} = identity) do
    %{
      "Address1" => identity.address1,
      "Address2" => identity.address2,
      "Address3" => identity.address3,
      "City" => identity.city,
      "Company" => identity.company,
      "Country" => identity.country,
      "Email" => identity.email,
      "FirstName" => identity.first_name,
      "MiddleName" => identity.middle_name,
      "LastName" => identity.last_name,
      "LicenseNumber" => identity.license_number,
      "PassportNumber" => identity.passport_number,
      "Phone" => identity.phone,
      "PostalCode" => identity.postal_code,
      "SSN" => identity.ssn,
      "State" => identity.state,
      "Title" => identity.title,
      "Username" => identity.username
    }
  end

  defp render_card(%Card{} = card) do
    %{
      "Brand" => card.brand,
      "CardholderName" => card.cardholder_name,
      "Code" => card.code,
      "ExpMonth" => card.exp_month,
      "ExpYear" => card.exp_year,
      "Number" => card.number
    }
  end

  defp render_secure_note(%SecureNote{} = note) do
    %{
      "Type" => note.type
    }
  end
end
