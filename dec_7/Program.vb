Imports System

Module Program
	Function CalcLinear(median As Integer, list As List(of Integer)) as Integer
		Dim diff = (
				From crab In list
				Select Math.Abs((crab - median))
			).Sum()
		Return diff
	End Function

	Function SumTo(limit As Integer) as Integer
		Return (1 + limit) * limit / 2
	End Function

	Function CalcExponential(median As Integer, list As List(of Integer)) as Integer
		Dim diff = (
				From crab In list
				Select SumTo(Math.Abs(crab-median))
			).Sum()
		Return diff
	End Function

	Sub Main(args As String())
		Dim read_line = Console.ReadLine()
		Dim list = (
				From crab In read_line.split(","c)
				Select Int32.Parse(crab)
			).ToList()

		list.Sort()

		Dim median = list(list.Count/2)
		Dim diff = CalcLinear(median, list)
		Console.WriteLine(diff)

		Dim max_value = (From i In list).Max()
		Dim part_two = (
				From i In Enumerable.Range(1, max_value)
				Select CalcExponential(i, list)
			).Min()
		Console.WriteLine(part_two)
	End Sub
End Module

