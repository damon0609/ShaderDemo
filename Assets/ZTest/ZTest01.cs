using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
public class ZTest01 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
      for(double i=-0.5;i<=0.5;i+=0.1)
      {
          Debug.Log(i+"==="+i%0.4);
      }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
