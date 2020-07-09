using UnityEngine;

public class Rain : MonoBehaviour
{
    public int max_count = 4096;
    public float range = 32;
    public Vector3[] vertex;
    int[] triangles;
    Color[] colors;
    Vector2[] uvs;
    public Vector3 pos1;
    private Matrix4x4 prev_view_matrix;

    void OnDrawGizmos()
    {
        if (vertex != null)
        {
            foreach (Vector3 p in vertex)
            {
                Gizmos.DrawSphere(p, 0.01f);
            }
        }

        if (prev_view_matrix != null)
        {
            prev_view_matrix = Camera.main.worldToCameraMatrix;
            Vector3 pos2 = prev_view_matrix.MultiplyPoint3x4(pos1);
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(pos2, 0.1f);
        }
    }

    void GenterateMesh()
    {
        prev_view_matrix = Camera.main.worldToCameraMatrix;
        vertex = new Vector3[max_count * 3];
        for (int i = 0; i < max_count; i++)
        {
            float x = Random.Range(-range, range);
            float y = Random.Range(-range, range);
            float z = Random.Range(-range, range);

            Vector3 pos = new Vector3(x, y, z);
            vertex[i * 3 + 0] = pos;
            vertex[i * 3 + 1] = pos;
            vertex[i * 3 + 2] = pos;
        }

        triangles = new int[max_count * 3];
        for (int i = 0; i < triangles.Length; i++)
        {
            triangles[i] = i;
        }

        colors = new Color[max_count * 3];
        for (int i = 0; i < max_count; i++)
        {
            colors[i * 3 + 0] = new Color(1, 1, 1, 0);
            colors[i * 3 + 1] = new Color(1, 1, 1, 1);
            colors[i * 3 + 2] = new Color(1, 1, 1, 0);
        }

        uvs = new Vector2[max_count * 3];
        for (int i = 0; i < max_count; i++)
        {
            uvs[i*3+0] = new Vector2(1f,0f);
            uvs[i*3+1] = new Vector2(1f, 0f);
            uvs[i*3+2] = new Vector2(0f, 1f);
        }

        Mesh mesh = new Mesh();
        mesh.name = "mesh";
        mesh.vertices = vertex;
        mesh.triangles = triangles;
        mesh.uv = uvs;
        mesh.colors = colors;
        mesh.bounds = new Bounds(Vector3.zero,Vector3.one*9999999999);
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.sharedMesh = mesh;
        meshFilter.mesh.SetIndices(triangles,MeshTopology.Lines,0);
    }

    void Start()
    {
        GenterateMesh();
    }

    void Update()
    {

    }
}
