ENV['RACK_ENV'] ||= 'development'
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require './wookie-life'

require File.expand_path(File.join(File.dirname(__FILE__), 'wookie-life'))

run WookieLife::WookieLifeApp
