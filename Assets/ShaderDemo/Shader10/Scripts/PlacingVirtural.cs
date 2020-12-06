using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PlacingVirtural : MonoBehaviour
{
    public GameObject reality;
    public GameObject mirror;
    void Start()
    {
        
    }
    void Update()
    {
        if(mirror!=null)
        {
            Matrix4x4 mirrorMatrix = mirror.GetComponent<Renderer>().worldToLocalMatrix;
            GetComponent<Renderer>().sharedMaterial.SetMatrix("_WorldMirror",mirrorMatrix);
            if(reality!=null)
            {
                Color realColor = reality.GetComponent<Renderer>().sharedMaterial.GetColor("_Color");
                GetComponent<Renderer>().sharedMaterial.SetColor("_Color",realColor);
            }

            transform.position = reality.transform.position;
            transform.rotation = reality.transform.rotation;
            transform.localScale = -reality.transform.localScale;

            transform.RotateAround(reality.transform.position,mirror.transform.TransformDirection(Vector3.up),180);
            Vector3 pos = mirror.transform.InverseTransformPoint(reality.transform.position);
            pos.y = -pos.y;
            transform.position = mirror.transform.TransformPoint(pos);
        }
    }
}
