﻿CREATE TABLE [dbo].[Comments] (
    [Id]           INT            NOT NULL,
    [CreationDate] DATETIME       NOT NULL,
    [PostId]       INT            NOT NULL,
    [Score]        INT            NULL,
    [Text]         NVARCHAR (700) NOT NULL,
    [UserId]       INT            NULL,
    CONSTRAINT [PK_Comments__Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

