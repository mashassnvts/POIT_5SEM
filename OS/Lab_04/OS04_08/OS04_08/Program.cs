using System;
using System.Threading;

namespace OS04_08
{
    class Program
    {
        const int ThreadCount = 24; 
        const int ObservationTime = 10; 
        static int[,] Matrix = new int[ThreadCount, ObservationTime];

        static void Main(string[] args)
        {
            Console.WriteLine("A student ... is placing threads to the pool...");

            for (int i = 0; i < ThreadCount; ++i)
            {
                object o = i; 
                ThreadPool.QueueUserWorkItem(WorkThread, o);
            }

            Console.WriteLine("A student ... is waiting for the threads to finish...");

            Thread.Sleep(1000 * ObservationTime);

            Console.WriteLine("\nРезультаты работы потоков:");
            for (int s = 0; s < ObservationTime; s++)
            {
                Console.Write("{0,3}: ", s);
                for (int th = 0; th < ThreadCount; th++)
                {
                    Console.Write("{0,5}", Matrix[th, s]);
                }
                Console.WriteLine();
            }
        }

        static void WorkThread(object state)
        {
            int threadIndex = (int)state;

            Random random = new Random();
            for (int s = 0; s < ObservationTime; s++)
            {
                Matrix[threadIndex, s] = random.Next(0, 10);
                Thread.Sleep(random.Next(100)); 
            }
        }
    }
}
