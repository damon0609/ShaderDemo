using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cube : MonoBehaviour
{

    public Vector3 p1;
    public Vector3 p2;
    public Vector3 p3;

    private MeshFilter meshFilter;
    private Vector3[] vertexs;
    private void OnDrawGizmos()
    {
        if (meshFilter == null)
        {
            meshFilter = transform.GetComponent<MeshFilter>();
            vertexs = meshFilter.sharedMesh.vertices;
        }


        Gizmos.color = Color.black;
        if (vertexs == null) return;
        for (int i = 0; i < vertexs.Length; i++)
        {
            Vector3 temp = transform.TransformPoint(vertexs[i]);
            Gizmos.DrawSphere(temp, 0.1f);
        }

        Gizmos.color = Color.blue;
        Gizmos.DrawSphere(p1, 0.1f);
        Gizmos.DrawSphere(p2, 0.1f);
        Gizmos.DrawSphere(p3, 0.1f);
        Vector3 p1p2 = p2 - p1;
        Vector3 p1p3 = p3 - p1;


        Gizmos.color = Color.black;
        Vector3 planeNormal = Vector3.Cross(p1p2.normalized, p1p3.normalized).normalized;

        Gizmos.DrawLine(p1, p2);
        Gizmos.DrawLine(p1, p3);
        Gizmos.DrawLine(p2, p3);

        Gizmos.color = Color.blue;
        Gizmos.DrawLine(p1, p1 + planeNormal);

        for (int i = 0; i < vertexs.Length; i++)
        {
            Vector3 temp = transform.TransformPoint(vertexs[i]);
            Vector3 dir = temp - p1;
            Gizmos.DrawLine(p1, p1 + dir);

            float cosQ = Vector3.Dot(dir.normalized, -planeNormal);
            float dis = dir.magnitude * cosQ;
            Vector3 target = -planeNormal.normalized * dis;
            Gizmos.DrawSphere(p1 + target, 0.1f);

            Gizmos.color = Color.white;
            Gizmos.DrawLine(temp, p1 + target);

        }
        Gizmos.color = Color.red;
        Gizmos.DrawLine(p1, p1 - planeNormal.normalized * 10);

    }

    void Start()
    {

    }

    void Update()
    {

    }
}
