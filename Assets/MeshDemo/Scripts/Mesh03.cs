using UnityEngine;
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Mesh03 : MonoBehaviour
{
    public Vector3 p1;
    public Vector3 p2;
    public Vector3 p3;
    public Vector3 p4;

    private void OnDrawGizmos()
    {
        if (meshFilter != null)
        {
            Gizmos.color = Color.red;
            Mesh mesh = meshFilter.sharedMesh;
            Vector3[] list = mesh.vertices;
            for (int i = 0; i < list.Length; i++)
            {
                Gizmos.DrawSphere(transform.TransformPoint(list[i]), 0.1f);
            }
            Gizmos.color = Color.blue;
            Vector3[] normals = mesh.normals;
            for (int j = 0; j < normals.Length; j++)
            {
                Vector3 start = transform.TransformPoint(list[j]);//世界空间下顶点坐标
                Vector3 end = start + transform.TransformDirection(normals[j]);//世界空间下法线
                Gizmos.DrawLine(start, end);
            }

            Gizmos.color = Color.yellow;
            Vector4[] tangents = mesh.tangents;
            for (int m = 0; m < tangents.Length; m++)
            {
                Vector4 point = transform.TransformDirection(tangents[m]).normalized;
                Vector3 start = transform.TransformPoint(list[m]);//世界空间下顶点坐标
                Gizmos.DrawLine(start, start+ new Vector3(point.x,point.y,point.z));
            }
            Gizmos.color = Color.green;
            for (int index = 0; index < normals.Length; index++)
            {
                Vector3 n = transform.TransformDirection(normals[index]);
                Vector3 t = transform.TransformDirection(tangents[index]);
                Vector3 b = Vector3.Cross(n,t)*tangents[index].w;//副切线

                Vector3 start = transform.TransformPoint(list[index]);//世界空间下顶点坐标
                Gizmos.DrawLine(start, start + b);
            }
        }
    }
    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;
    private Mesh tempMesh;
    private void Start()
    {

    }
    [ContextMenu("GenerateMesh")]
    void GenerateMesh()
    {
        meshFilter = transform.GetComponent<MeshFilter>();
        meshRenderer = transform.GetComponent<MeshRenderer>();

        tempMesh = new Mesh();
        tempMesh.name = "tempMesh";
        tempMesh.vertices = new Vector3[4] { p1, p2, p3, p4 };
        tempMesh.triangles = new int[6] { 0, 3, 1, 1, 3, 2 };
        tempMesh.uv = new Vector2[4] { new Vector2(0, 0), new Vector2(1, 0), new Vector2(1, 1),new Vector2(0,1) };
        tempMesh.RecalculateNormals();
        tempMesh.RecalculateBounds();
        tempMesh.RecalculateTangents();

        meshFilter.mesh = tempMesh;
    }
}
