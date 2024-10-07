using System;
using System.Threading;

class Program
{
    const int ThreadCount = 24; 
    const int ThreadLifeTime = 10; 
    const int ObservationTime = 30;
    static int[,] Matrix = new int[ThreadCount, ObservationTime]; 
    static DateTime StartTime = DateTime.Now; 

    static void MySleep(int ms)
    {
        double sum = 0;
        for (int t = 0; t < ms; ++t)
        {
            double temp = 0.711 + (double)t / 10000.0;
            double a, b, c, d, e, nt;
            for (int k = 0; k < 5500; ++k)
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
        Thread.Sleep(ms);
    }

    static void WorkThread(object o)
    {
        int id = (int)o;
        DateTime threadStartTime = DateTime.Now; 

        while ((DateTime.Now - threadStartTime).TotalSeconds < ThreadLifeTime)
        {
            int elapsedSeconds = (int)(DateTime.Now - StartTime).TotalSeconds; 

            if (elapsedSeconds >= ObservationTime || elapsedSeconds < 0)
                break;

            Matrix[id, elapsedSeconds] += 1;
            MySleep(100);
        }
    }

    static void Main(string[] args)
    {
        Thread[] t = new Thread[ThreadCount];

        for (int i = 0; i < ThreadCount; ++i)
        {
            t[i] = new Thread(WorkThread);
            t[i].Start(i); 
        }

        Console.WriteLine("A student ... is waiting for the threads to finish");

        for (int i = 0; i < ThreadCount; ++i)
        {
            t[i].Join();
        }

        Console.WriteLine("\nРезультаты работы потоков:");
        for (int s = 0; s < ObservationTime; s++)
        {
            Console.Write("{0,3}: ", s);
            for (int th = 0; th < ThreadCount; th++)
            {
                Console.Write(" {0,5}", Matrix[th, s]);
            }
            Console.WriteLine();
        }
    }
}
