:- consult('streamIO.pl').
:- consult('utils.pl').
:- consult('menu.pl').
:- consult('game.pl').
:- consult('board.pl').

:- use_module(library(between)).
:- use_module(library(lists)).

play:-
    menu(main).