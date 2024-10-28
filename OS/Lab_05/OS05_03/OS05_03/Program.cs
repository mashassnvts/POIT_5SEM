//using System;
//using System.Diagnostics;
//using System.Linq;
//using System.Threading;

//class Program
//{
//    const int ThreadCount = 25;
//    const int ThreadLifeTime = 10;
//    const int ObservationTime = 30;
//    static int[,] Matrix = new int[ThreadCount, ObservationTime];
//    static DateTime StartTime;

//    static void WorkThread(object o)
//    {
//        int id = (int)o;

//        ProcessThread currentThread = Process.GetCurrentProcess().Threads[id];
//        currentThread.ProcessorAffinity = (IntPtr)(1 << (id % 12));

//        for (int i = 0; i < ThreadLifeTime * 20; i++)
//        {
//            DateTime CurrentTime = DateTime.Now;
//            int ElapsedSeconds = (int)(CurrentTime - StartTime).TotalSeconds;

//            if (ElapsedSeconds >= 0 && ElapsedSeconds < ObservationTime)
//            {
//                Matrix[id, ElapsedSeconds] += 50;
//            }

//            MySleep(50);
//        }
//    }

//    static void Main(string[] args)
//    {
//        StartTime = DateTime.Now;
//        Thread[] threads = new Thread[ThreadCount];

//        for (int i = 0; i < ThreadCount; ++i)
//        {
//            threads[i] = new Thread(WorkThread);
//            switch (i % 3)
//            {
//                case 0:
//                    threads[i].Priority = ThreadPriority.Lowest;
//                    break;
//                case 2:
//                    threads[i].Priority = ThreadPriority.Highest;
//                    break;
//            }
//            threads[i].Start(i);
//        }

//        Console.WriteLine("A student Masha Sosnovets is waiting for the threads to finish");
//        for (int i = 0; i < ThreadCount; ++i)
//            threads[i].Join();

//        Console.WriteLine("\nРезультат работы потоков:");
//        Console.WriteLine("Time| " + string.Join(" | ", Enumerable.Range(0, ThreadCount).Select(i => $"   {i}")));
//        Console.WriteLine(new string('=', 85));

//        for (int s = 0; s < ObservationTime; s++)
//        {
//            Console.Write($"{s,3} | ");
//            for (int th = 0; th < ThreadCount; th++)
//            {
//                Console.Write($"{Matrix[th, s],5} | ");
//            }
//            Console.WriteLine();
//        }
//    }

//    static void MySleep(int milliseconds)
//    {
//        DateTime endTime = DateTime.Now.AddMilliseconds(milliseconds);
//        while (DateTime.Now < endTime)
//        {
//            ComputeFibonacci(20);
//        }
//    }

//    static long ComputeFibonacci(int n)
//    {
//        if (n <= 1)
//            return n;
//        return ComputeFibonacci(n - 1) + ComputeFibonacci(n - 2);
//    }
//}



using System;
using System.Diagnostics;
using System.Linq;
using System.Threading;

class Program
{
    const int ThreadCount = 25;
    const int ThreadLifeTime = 10;
    const int ObservationTime = 30;
    static int[,] Matrix = new int[ThreadCount, ObservationTime];
    static DateTime StartTime;

    static void WorkThread(object o)
    {
        int id = (int)o;

        ProcessThread currentThread = Process.GetCurrentProcess().Threads[id];
        currentThread.ProcessorAffinity = (IntPtr)(1 << (id % 12));

        for (int i = 0; i < ThreadLifeTime * 20; i++)
        {
            DateTime CurrentTime = DateTime.Now;
            int ElapsedSeconds = (int)(CurrentTime - StartTime).TotalSeconds;

            if (ElapsedSeconds >= 0 && ElapsedSeconds < ObservationTime)
            {
                Matrix[id, ElapsedSeconds] += 50;
            }

            MySleep(50);
        }
    }

    static void Main(string[] args)
    {
        StartTime = DateTime.Now;
        Thread[] threads = new Thread[ThreadCount];

        for (int i = 0; i < ThreadCount; ++i)
        {
            threads[i] = new Thread(WorkThread);
            switch (i % 2)
            {
                case 0:
                    threads[i].Priority = ThreadPriority.BelowNormal;
                    break;
                case 1:
                    threads[i].Priority = ThreadPriority.Normal;
                    break;
            }
            threads[i].Start(i);
        }

        Console.WriteLine("A student Masha Sosnovets is waiting for the threads to finish");
        for (int i = 0; i < ThreadCount; ++i)
            threads[i].Join();

        Console.WriteLine("\nРезультат работы потоков:");
        Console.WriteLine("Time| " + string.Join(" | ", Enumerable.Range(0, ThreadCount).Select(i => $"   {i}")));
        Console.WriteLine(new string('=', 85));

        for (int s = 0; s < ObservationTime; s++)
        {
            Console.Write($"{s,3} | ");
            for (int th = 0; th < ThreadCount; th++)
            {
                Console.Write($"{Matrix[th, s],5} | ");
            }
            Console.WriteLine();
        }
    }

    static void MySleep(int milliseconds)
    {
        DateTime endTime = DateTime.Now.AddMilliseconds(milliseconds);
        while (DateTime.Now < endTime)
        {
            ComputeFibonacci(20);
        }
    }

    static long ComputeFibonacci(int n)
    {
        if (n <= 1)
            return n;
        return ComputeFibonacci(n - 1) + ComputeFibonacci(n - 2);
    }
}
