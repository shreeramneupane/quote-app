require 'rails_helper'

RSpec.describe 'Quotes', type: :request do
  describe 'GET /quote' do
    context 'when there are quotes' do
      let!(:quote) { create(:quote) }

      context 'incase of json request' do
        let(:body) { JSON.parse(response.body) }

        it 'should return a single quote in json format' do
          get '/quote.json'

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to render_template(:random)

          expect(body['title']).to eq quote.title
          expect(body['author']).to eq quote.author
        end
      end

      context 'incase of html request' do
        it 'should return a single quote in html format' do
          get '/quote'

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('text/html; charset=utf-8')
          expect(response).to render_template(:random)

          expect(response.body).to include("<h1>#{quote.title}</h1>")
          expect(response.body).to include("<p>#{quote.author}</p>")
        end
      end

      context 'incase of xml request' do
        it 'should return a single quote in xml format' do
          get '/quote.xml'

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/xml; charset=utf-8')
          expect(response).to render_template(:random)

          expect(response.body).to include("<title>#{quote.title}</title>")
          expect(response.body).to include("<author>#{quote.author}</author>")
        end
      end
    end

    context 'when there are no any quote' do
      context 'incase of json request' do
        let(:body) { JSON.parse(response.body) }

        it 'should return a nil values in json format' do
          get '/quote.json'

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to render_template(:random)

          expect(body['title']).to eq nil
          expect(body['author']).to eq nil
        end

        context 'incase of html request' do
          it 'should return a `No quote` html' do
            get '/quote'

            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq('text/html; charset=utf-8')
            expect(response).to render_template(:random)

            expect(response.body).to include('<p>No quote</p>')
          end
        end

        context 'incase of xml request' do
          it 'should return a empty in xml format' do
            get '/quote.xml'

            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq('application/xml; charset=utf-8')
            expect(response).to render_template(:random)

            expect(response.body).to include("<title></title>")
            expect(response.body).to include("<author></author>")
          end
        end
      end
    end
  end
end
