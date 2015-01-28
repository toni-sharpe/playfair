require "spec_helper"
require "encrypter"

describe Encrypter do

	let(:encrypter) { Encrypter.new('THIS IS A TEST MESSAGE - THIS TEST MESSAGE MUST BE ENCRYPTED CAREFULLY', CryptBoard.new('PLAYFAIRCYPHER'), Input.new( 'data/crypt_data.txt' )) }

	it "should store the unencrypted message" do
		expect( encrypter.message ).to be_kind_of (String)
		expect( encrypter.message.length ).to be > 0
	end

	context "Boxes - functionality identical whether encrypting or decrypting" do

		it "should replace any two characters on the corners of squares where both dimensions are at least 2 with the characters from the opposite corners - character rows must be kept in the same order" do
			expect( encrypter.encrypt_pair('R','X') ).to be == ['H','V']
			expect( encrypter.encrypt_pair('V','Y') ).to be == ['X','L']
			expect( encrypter.encrypt_pair('Z','P') ).to be == ['U','F']
			expect( encrypter.encrypt_pair('D','Q') ).to be == ['G','O']
			expect( encrypter.encrypt_pair('B','T') ).to be == ['M','N']
			expect( encrypter.encrypt_pair('A','X') ).to be == ['Y','W']
		end

	end

	context "Encrypting" do		

		it "should strip the spaces" do
			encrypter.strip_spaces
			expect( encrypter.message ).to be == 'THISISATESTMESSAGETHISTESTMESSAGEMUSTBEENCRYPTEDCAREFULLY'
		end

		it "should append a 'Z' if it's got an odd number of chars" do
			encrypter.strip_spaces
			encrypter.handle_odd_char_count
			expect( encrypter.message ).to be == 'THISISATESTMESSAGETHISTESTMESSAGEMUSTBEENCRYPTEDCAREFULLYZ'
		end

		it "should replace any pair of equal characters in the message with the string <char1><q>" do
			encrypter.strip_spaces
			encrypter.handle_odd_char_count
			encrypter.make_pairs
			expect( encrypter.message ).to be == 'THISISATESTMESSAGETHISTESTMESQAGEMUSTBEQNCRYPTEDCAREFULQYZ'
		end

		context "Rows and columns" do

			it "should replace a pair of characters in the same row with the characters one cell to the right" do
				expect( encrypter.encrypt_pair('P','L') ).to be == ['L','A']
			end

			it "should replace the character in cell five with the character in cell one of the same row" do
				expect( encrypter.encrypt_pair('Y','F') ).to be == ['F','P']
			end

			it "should replace a pair of characters in the same column with the characters one cell down" do
				expect( encrypter.encrypt_pair('D','O') ).to be == ['O','V']
			end

			it "should replace the character in cell five with the character in cell one of the same column" do
				expect( encrypter.encrypt_pair('S','X') ).to be == ['X','Y']
			end

		end

		it "should create an encrypted message" do
			encrypter.strip_spaces
			encrypter.handle_odd_char_count
			encrypter.make_pairs
			encrypter.encrypt_message
			expect( encrypter.encrypted_message ).to be == 'SEHNHNFQHTZTHTQYMCSEHNZMTNTMTSCQMTXNNMCTQIHLFNRMGCCIPZAOFX'
		end

	end

	context "Decrypting" do

		context "Rows and columns" do

			it "should replace a pair of characters in the same row with the characters one cell to the left" do
				expect( encrypter.encrypt_pair('L','A',false) ).to be == ['P','L']
			end

			it "should replace the character in cell one with the character in cell five of the same row" do
				expect( encrypter.encrypt_pair('F','P',false) ).to be == ['Y','F']
			end

			it "should replace a pair of characters in the same column with the characters one cell down" do
				expect( encrypter.encrypt_pair('O','V',false) ).to be == ['D','O']
			end

			it "should replace the character in cell one with the character in cell five of the same column" do
				expect( encrypter.encrypt_pair('X','Y',false) ).to be == ['S','X']
			end

		end

		it "should store the unencrypted message" do
			encrypter.strip_spaces
			encrypter.handle_odd_char_count
			encrypter.make_pairs
			encrypter.encrypt_message
			encrypter.decrypt_message
			expect( encrypter.unencrypted_message ).to be == 'THISISATESTMESSAGETHISTESTMESQAGEMUSTBEQNCRYPTEDCAREFULQYZ'

		end

	end

end