:- consult('data.pl').
:- consult('streamIO.pl').
:- consult('utils.pl').
:- consult('menu.pl').
:- consult('game.pl').
:- consult('board.pl').

:- use_module(library(between)).
:- use_module(library(lists)).

%play/0
%Starts the game (calls the main menu)
play:-
    menu(main).