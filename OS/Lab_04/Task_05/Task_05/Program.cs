using System;
using System.Diagnostics;

class Program
{
    static double MySleep(int ms)
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();

        double sum = 0, temp;
        int iterations = 5500;  
        while (stopwatch.ElapsedMilliseconds < ms)
        {
            for (int t = 0; t < ms; ++t)
            {
                temp = 0.711 + (double)t / 10000.0;
                double a, b, c, d, e, nt;
                for (int k = 0; k < iterations; ++k)
                {
                    nt = temp - k / 27000.0;
                    a = Math.Sin(nt);
                    b = Math.Cos(nt);
                    c = Math.Cos(nt / 2.0);
                    d = Math.Sin(nt / 2.0);
                    e = Math.Abs(1.0 - a * a - b * b) + Math.Abs(1.0 - c * c - d * d);
                    sum += e;
                }
            }
        }

        stopwatch.Stop();
        return sum;
    }

    static void Main()
    {
        int milliseconds = 10000;
        Console.WriteLine($"Starting MySleep({milliseconds})...");
        double result = MySleep(milliseconds);
        Console.WriteLine($"Finished MySleep. Result: {result}");
    }
}
