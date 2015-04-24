-- Generated by Creer, git hash c6767247662bdc8024518de1aebc87bcf634ca49
-- This is a simple class to represent the Game object in the game. You can extend it by adding utility functions here in this file.

local class = require("utilities.class")
local BaseGame = require("baseGame")

--- @class Game: The simple version of American Checkers. An 8x8 board with 12 checkers on each side that much move diagonally to the opposing side. Very simple.
local Game = class(BaseGame)

--- initializes a Game with basic logic as provided by the Creer code generator
-- @param <table> data: initialization data
function Game:init(data)
    BaseGame.init(self, data)

    if data.maxTurns == nil then -- set to default value because it was not sent
        self.maxTurns = 100
    else
        self.maxTurns = tonumber(data.maxTurns)
    end

    if data.boardHeight == nil then -- set to default value because it was not sent
        self.boardHeight = 8
    else
        self.boardHeight = tonumber(data.boardHeight)
    end

    if data.checkers == nil then -- set to default value because it was not sent
        self.checkers = Table()
    else
        self.checkers = (data.checkers)
    end

    if data.checkerMovedJumped == nil then -- set to default value because it was not sent
        self.checkerMovedJumped = false
    else
        self.checkerMovedJumped = (data.checkerMovedJumped)
    end

    if data.gameObjects == nil then -- set to default value because it was not sent
        self.gameObjects = Table()
    else
        self.gameObjects = (data.gameObjects)
    end

    if data.checkerMoved == nil then -- set to default value because it was not sent
        self.checkerMoved = nil
    else
        self.checkerMoved = (data.checkerMoved)
    end

    if data.currentPlayer == nil then -- set to default value because it was not sent
        self.currentPlayer = nil
    else
        self.currentPlayer = (data.currentPlayer)
    end

    if data.currentPlayers == nil then -- set to default value because it was not sent
        self.currentPlayers = Table()
    else
        self.currentPlayers = (data.currentPlayers)
    end

    if data.currentTurn == nil then -- set to default value because it was not sent
        self.currentTurn = 0
    else
        self.currentTurn = tonumber(data.currentTurn)
    end

    if data.players == nil then -- set to default value because it was not sent
        self.players = Table()
    else
        self.players = (data.players)
    end

    if data.boardWidth == nil then -- set to default value because it was not sent
        self.boardWidth = 8
    else
        self.boardWidth = tonumber(data.boardWidth)
    end


    self.name = "Checkers"

    self._gameObjectClasses = {
        GameObject = require("Checkers.gameObject"),
        Player = require("Checkers.player"),
        Checker = require("Checkers.checker"),
    }
end


return Game