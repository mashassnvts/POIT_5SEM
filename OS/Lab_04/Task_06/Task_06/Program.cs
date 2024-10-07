using System;
using System.Threading;

class Program
{
    static int Count = 0;
    static object lockObject = new object(); 

    static void WorkThread()
    {
        for (int i = 0; i < 5000000; ++i)
        {
            lock (lockObject) 
            {
                Count = Count + 1;
            }
        }
    }

    static void Main(string[] args)
    {
        Thread[] threads = new Thread[20]; 

        for (int i = 0; i < 20; ++i)
        {
            threads[i] = new Thread(WorkThread);
            threads[i].Start();
        }

        for (int i = 0; i < 20; ++i)
        {
            threads[i].Join();
        }

        Console.WriteLine($"Результат Count: {Count}");
        Console.WriteLine($"Ожидаемое значение: {20 * 5000000}");
    }
}
