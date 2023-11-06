:- consult('data.pl').
:- consult('streamIO.pl').
:- consult('utils.pl').
:- consult('menu.pl').
:- consult('game.pl').
:- consult('board.pl').

:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(random)).

%play/0
%Starts the game (calls the main menu)
play:-
    menu(main).