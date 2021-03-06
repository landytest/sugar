﻿namespace Sugar.Test;

interface

uses
  Sugar,
  Sugar.TestFramework;

type
  GuidTest = public class (Testcase)
  private
    Data: Guid;
    GuidString: String := "{5EB4BEC4-5509-4434-9D33-2A9C74CC54EE}";
    method AreEqual(Expected, Actual: Guid);
    method AreNotEqual(Expected, Actual: Guid);
  public
    method Setup; override;
    method CompareTo;
    method TestEquals;
    method NewGuid;
    method Parse;
    method ParseExceptions;
    method EmptyGuid;
    method ToByteArray;
    method TestToString;
    method ToStringFormat;
    method Constructors;
  end;

implementation

method GuidTest.Setup;
begin
  Data := Guid.Parse(GuidString);
end;

method GuidTest.AreEqual(Expected: Guid; Actual: Guid);
begin
  Assert.CheckBool(true, Expected.Equals(Actual));
end;

method GuidTest.AreNotEqual(Expected: Guid; Actual: Guid);
begin
  Assert.CheckBool(false, Expected.Equals(Actual));
end;

method GuidTest.CompareTo;
begin
  Assert.CheckInt(0, Data.CompareTo(Data));
  var Value := Guid.Parse(GuidString);
  Assert.CheckInt(0, Data.CompareTo(Value));
  Assert.CheckBool(true, Data.CompareTo(Guid.EmptyGuid) <> 0);
  Value := Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}");
  Assert.CheckBool(true, Data.CompareTo(Value) <> 0);
  Assert.CheckInt(0, Guid.EmptyGuid.CompareTo(Guid.EmptyGuid));
end;

method GuidTest.TestEquals;
begin
  Assert.CheckBool(true, Data.Equals(Data));
  var Value := Guid.Parse(GuidString);
  Assert.CheckBool(true, Data.Equals(Value));
  Assert.CheckBool(false, Data.Equals(Guid.EmptyGuid));
  Value := Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}");
  Assert.CheckBool(false, Data.Equals(Value));
  Assert.CheckBool(true, Guid.EmptyGuid.Equals(Guid.EmptyGuid));
end;

method GuidTest.NewGuid;
begin
  var Value := Guid.NewGuid;
  Assert.CheckBool(false, Value.Equals(Guid.EmptyGuid));
end;

method GuidTest.Parse;
begin
  AreEqual(Guid.EmptyGuid, Guid.Parse("00000000-0000-0000-0000-000000000000"));
  AreEqual(Guid.EmptyGuid, Guid.Parse("{00000000-0000-0000-0000-000000000000}"));
  AreEqual(Guid.EmptyGuid, Guid.Parse("(00000000-0000-0000-0000-000000000000)"));  

  AreEqual(Data, Guid.Parse(GuidString));
  AreNotEqual(Guid.EmptyGuid, Guid.Parse(GuidString));
  AreEqual(Data, Guid.Parse("5EB4BEC4-5509-4434-9D33-2A9C74CC54EE"));
  AreEqual(Data, Guid.Parse("(5EB4BEC4-5509-4434-9D33-2A9C74CC54EE)"));
end;

method GuidTest.ParseExceptions;
begin
  Assert.IsException(->Guid.Parse(""));
  Assert.IsException(->Guid.Parse(nil));
  Assert.IsException(->Guid.Parse("String"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C74CC54EE"));
  Assert.IsException(->Guid.Parse("5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("(5EB4BEC4-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4-55109-4434-9D44-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4-5509-44314-9D44-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4-5509-4434-9D414-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C744CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4-5509-4434-9D44-2A9C4CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BECJ-5509-4434-9D44-2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4 5509 4434 9D44 2A9C74CC54EE}"));
  Assert.IsException(->Guid.Parse("{5EB4BEC4550944349D442A9C74CC54EE}"));  
  Assert.IsException(->Guid.Parse("00000000000000000000000000000000"));
  Assert.IsException(->Guid.Parse("0"));
end;

method GuidTest.EmptyGuid;
begin
  AreEqual(Guid.Parse("{00000000-0000-0000-0000-000000000000}"), Guid.EmptyGuid);
  var Value := Guid.EmptyGuid.ToByteArray;
  for i: Int32 := 0 to length(Value)-1 do 
    Assert.CheckInt(0, Value[i]);
end;

method GuidTest.ToByteArray;
begin
  var Expected: array of Byte := [94, 180, 190, 196, 85, 9, 68, 52, 157, 51, 42, 156, 116, 204, 84, 238];
  var Actual := Data.ToByteArray;
  Assert.CheckInt(16, length(Actual));
  for i: Int32 := 0 to length(Expected)-1 do 
    Assert.CheckInt(Expected[i], Actual[i]);

  Actual := Guid.EmptyGuid.ToByteArray;
  Assert.CheckInt(16, length(Actual));
  for i: Int32 := 0 to length(Expected)-1 do 
    Assert.CheckInt(0, Actual[i]);
end;

method GuidTest.TestToString;
begin
  //ToString should return string in "default" format
  Assert.CheckString("5EB4BEC4-5509-4434-9D33-2A9C74CC54EE", Data.ToString);
  Assert.CheckString(Data.ToString(GuidFormat.Default), Data.ToString);
end;

method GuidTest.ToStringFormat;
begin
  Assert.CheckString(GuidString, Data.ToString(GuidFormat.Braces));
  Assert.CheckString("(5EB4BEC4-5509-4434-9D33-2A9C74CC54EE)", Data.ToString(GuidFormat.Parentheses));
  Assert.CheckString("5EB4BEC4-5509-4434-9D33-2A9C74CC54EE", Data.ToString(GuidFormat.Default));
end;

method GuidTest.Constructors;
begin
  var Value := new Guid().ToByteArray;
  for i: Int32 := 0 to length(Value)-1 do 
    Assert.CheckInt(0, Value[i]);

  var Expected: array of Byte := [94, 180, 190, 196, 85, 9, 68, 52, 157, 51, 42, 156, 116, 204, 84, 238];
  var Actual := new Guid(Expected);
  Assert.IsNotNull(Actual);
  Assert.CheckBool(true, Data.Equals(Actual));
end;

end.
