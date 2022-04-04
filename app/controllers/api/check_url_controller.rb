# 1. Create a simple API Web Server (using rails) similar to PhishTank API service.
# PhishTank is a free online service, which stores information about Phishing URLs.
# It should have one POST endpoint named "checkurl" which accepts the following Request Body Parameters
# and returns the response with following Response Fields.
#              Implement a demo function which will utilize the functionality

# Request Body Parameter:
# - url: encoded url
# - format: “json” | “xml”

# Response Fields:
# - url: URL passed in input
# - is_valid: yes | no | unknown

# Server will have one static hard-coded csv file with two columns "url" and "is_valid".
# For each request, check if csv file contains entry for that url,
# if yes then return is_valid field accordingly else return is_valid as unknown.

# Sample CSV File:
# url, is_valid
# https://google.com, yes
# https://dummy.com, no

require 'csv'

class Api::CheckUrlController < ApplicationController
  def index
    render json: { satus: 'Running', method: :post, url: '/api/check_url' }
  end

  def create
    _url = params[:url]
    _format = params[:format] || 'json'

    if _url.nil?
      render json: { error: 'Url not provided' }, status: 400
      return
    end

    res = {
      url: _url,
      is_valid: 'unknown'
    }

    table = CSV.read('./db/urls.csv', headers: true)

    for row in table
      if row[0] == _url
        res[:is_valid] = row[1]
        break
      end
    end

    render _format == 'xml' ? { xml: res } : { json: res }
  rescue StandardError => e
    render json: { error: e }, status: 500
  end
end
