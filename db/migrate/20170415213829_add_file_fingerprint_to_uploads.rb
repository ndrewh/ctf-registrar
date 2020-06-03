class AddFileFingerprintToUploads < ActiveRecord::Migration[4.2][5.0]
  def change
    add_column :uploads, :file_fingerprint, :binary
  end
end
