using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapsuleTest : MonoBehaviour
{
    private Material material;

    public Transform plane;

    private int upDir;
    private int point;

    private Vector3 mPoint;
    private Vector3 planeNormal;
    void Start()
    {
        upDir = Shader.PropertyToID("_PlaneNormal");
        point = Shader.PropertyToID("_Point");
        material = transform.GetComponent<MeshRenderer>().material;


    }

    private void OnDrawGizmos()
    {
        if (plane == null) return;
        UpdatePos();
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(mPoint, mPoint + planeNormal.normalized * 2);
    }

    void UpdatePos()
    {
        mPoint = plane.TransformPoint(Vector3.zero);
        planeNormal = plane.TransformPoint(plane.rotation * plane.up+mPoint);
    }

    void Update()
    {

    }
}
