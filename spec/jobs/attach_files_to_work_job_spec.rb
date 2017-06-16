# frozen_string_literal: true
require 'rails_helper'

describe AttachFilesToWorkJob do
  context "happy path" do
    let(:file1) { File.open(fixture_path + '/world.png') }
    let(:file2) { File.open(fixture_path + '/image.jp2') }
    let(:uploaded_file1) { Hyrax::UploadedFile.create(file: file1) }
    let(:uploaded_file2) { Hyrax::UploadedFile.create(file: file2) }
    let(:generic_work) { create(:public_generic_work) }

    context "with uploaded files on the filesystem" do
      before do
        generic_work.permissions.build(name: 'userz@bbb.ddd', type: 'person', access: 'edit')
        generic_work.save
      end
      it "attaches files, copies visibility and permissions and updates the uploaded files" do
        expect(CharacterizeJob).to receive(:perform_later).twice
        described_class.perform_now(generic_work, [uploaded_file1, uploaded_file2])
        generic_work.reload
        expect(generic_work.file_sets.count).to eq 2
        expect(generic_work.file_sets.map(&:visibility)).to all(eq 'open')
        expect(generic_work.file_sets.map(&:edit_users)).to all(match_array([generic_work.depositor, 'userz@bbb.ddd']))
        expect(uploaded_file1.reload.file_set_uri).not_to be_nil
      end
    end

    context "with uploaded files at remote URLs" do
      let(:url1) { 'https://example.com/my/img.png' }
      let(:url2) { URI('https://example.com/other/img.png') }
      let(:fog_file1) { double(CarrierWave::Storage::Abstract, url: url1) }
      let(:fog_file2) { double(CarrierWave::Storage::Abstract, url: url2) }

      before do
        allow(uploaded_file1.file).to receive(:file).and_return(fog_file1)
        allow(uploaded_file2.file).to receive(:file).and_return(fog_file2)
      end

      it 'creates ImportUrlJobs' do
        expect(ImportUrlJob).to receive(:perform_later).twice
        described_class.perform_now(generic_work, [uploaded_file1, uploaded_file2])
        generic_work.reload
        expect(generic_work.file_sets.count).to eq 2
        expect(generic_work.file_sets.map(&:visibility)).to all(eq 'open')
        expect(uploaded_file1.reload.file_set_uri).not_to be_nil
      end
    end
  end
end
